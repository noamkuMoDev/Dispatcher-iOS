import Foundation

enum userType {
    case loggedOut
    case loggedIn
}

class AuthRepository {
    
    let firebaseManager = FirebaseAuthManager()
    let keychainManager = KeychainManager()
    
    func checkIfLoggedIn() -> userType {
        
        do {
            _ = try keychainManager.fetchFromKeychain(
                service: Constants.Keychain.SERVICE,
                account: Constants.Keychain.ACCOUNT_USER_EMAIL,
                secClass: kSecClassGenericPassword as String
            )
            if firebaseManager.isUserLoggedIn() {
                return .loggedIn
            }
        } catch {
            print(error)
        }
        return .loggedOut
    }
    

    func signUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        saveUserEmailToKeychain(email) { error in
            if let error = error {
                completionHandler("Error saving email to keychain: \(error)")
            } else {
                self.firebaseManager.signupUser(email: email, password: password) {error in
                    completionHandler(error)
                }
            }
        }
    }
    
    
    func logUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        firebaseManager.loginUser(email: email, password: password) { error in
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
                self.saveUserEmailToKeychain(email) { error in
                    if let error = error {
                        completionHandler("Error saving email to keychain: \(error)")
                    } else {
                        completionHandler(nil)
                    }
                }
            }
        }
    }
    
    
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
}
