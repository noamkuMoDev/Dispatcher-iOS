import Foundation

enum userType {
    case loggedOut
    case loggedIn
}

class AuthRepository {
    
    let firebaseAuthManager = FirebaseAuthManager()
    let firestoreManager = FirestoreManager()
    let keychainManager = KeychainManager()
    let userDefaultsManager = UserDefaultsManager()
    
    // LOGIN FLOW - V
    func checkIfLoggedIn() -> userType {
        print("Auth REPOSITORY - trying to read from KEYCHAIN")
        do {
            _ = try keychainManager.fetchFromKeychain(
                service: Constants.Keychain.SERVICE,
                account: Constants.Keychain.ACCOUNT_USER_EMAIL,
                secClass: kSecClassGenericPassword as String
            )
            print("KEYCHAIN WORKED, calling FIREBASE to check if login")
            if firebaseAuthManager.isUserLoggedIn() {
                print("firebase auth confirmed login")
                return .loggedIn
            }
        } catch { // can't find email in keychain
            print(error)
        }
        return .loggedOut
    }
    
    
    // LOGIN FLOW - V
    func fetchCurrentUserDetails(completionHandler: @escaping (String?) -> ()) {
        let uid = firebaseAuthManager.getCurrentUserUID()
        if uid != nil {
            firestoreManager.fetchCurrentUserDetails(uid: uid!) { error, data in
                if let error = error {
                    completionHandler(error)
                } else {
                    self.userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.CURRENT_USER_NAME, data: data!["name"])
                    self.saveUserEmailToKeychain(data!["email"] as! String) { error in
                        completionHandler(error)
                    }
                }
            }
        } else {
            completionHandler("Couldn't find current user uid")
        }
    }
    
    
    // LOGIN FLOW - V
    func logUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        firebaseAuthManager.loginUser(email: email, password: password) { error in
            var errorDescription = ""
            if let error = error {
                if error.contains("There is no user record") {
                    errorDescription = "Couldn't find a match to given credentials"
                } else if error.contains("The password is invalid") {
                    errorDescription = "Incorrect password"
                } else {
                    errorDescription = error
                }
                completionHandler("Unexpected error: \(errorDescription)")
            } else {
                self.fetchCurrentUserDetails() { error in
                    self.saveDefaultAppSettingsToUserDefaults()
                    completionHandler(error)
                }
            }
        }
    }
    
    
    // SIGNUP FLOW - V
    func signUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        firebaseAuthManager.signupUser(email: email, password: password) {error, userName, userUID in
            if let error = error { // something went wrong
                completionHandler(error)
            } else {
                self.saveDefaultAppSettingsToUserDefaults()
                self.userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.CURRENT_USER_UID, data: userUID)
                self.userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.CURRENT_USER_NAME, data: userName)
                self.saveUserEmailToKeychain(email) { error in
                    completionHandler(error)
                }
            }
        }
    }
    
    
    func isValidEmailAddress(_ email: String) -> Bool {
        var isValidEmail = true
        let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegex)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                isValidEmail = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            isValidEmail = false
        }
        
        return  isValidEmail
    }
    
    func isStrongPassword(_ password: String) -> Bool {
        
        var isStrongPassword = true
        //Minimum 8 characters - at least 1 Uppercase, 1 Lowercase, 1 Number, 1 Special Character
        let strongPasswoedRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        do {
            let regex = try NSRegularExpression(pattern: strongPasswoedRegex)
            let nsString = password as NSString
            let results = regex.matches(in: password, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                isStrongPassword = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            isStrongPassword = false
        }
        
        return  isStrongPassword
    }
    
    // V
    private func saveUserEmailToKeychain(_ email: String, completionHandler: @escaping (String?) -> ()) {
        do {
            try self.keychainManager.addToKeychain(
                data: Data(email.utf8),
                service: Constants.Keychain.SERVICE,
                account: Constants.Keychain.ACCOUNT_USER_EMAIL,
                secClass: kSecClassGenericPassword as String
            ){
                completionHandler(nil)
            }
        } catch {
            completionHandler(error.localizedDescription)
        }
    }
    
    // LOGIN & SIGNUP FLOW - V
    private func saveDefaultAppSettingsToUserDefaults() {
        self.userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SAVE_FILTERS, data: 1)
        self.userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SEND_NOTIFICATIONS, data: 1)
        self.userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SAVE_SEARCH_RESULTS, data: 1)
    }
}
