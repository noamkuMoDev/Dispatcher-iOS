import Foundation

enum userType {
    case loggedOut
    case loggedIn
}

class AuthRepository {
    
    let firebaseManager = FirebaseAuthManager()
    let keychainManager = KeychainManager()
    
    func checkIfLoggedIn() -> userType {
        
        //check password from keychain
        do {
            let data = try keychainManager.fetchFromKeychain(service: "dispatcher.moveo", account: "currentUserPassword", secClass: kSecClassGenericPassword as String)
            let password = String(decoding: data!, as: UTF8.self)
            print("User's password is:\(password)")
        } catch {
            print(error)
        }
        
        //check email from keychain
        do {
            let data = try keychainManager.fetchFromKeychain(service: "dispatcher.moveo", account: "currentUserEmail", secClass: kSecClassIdentity as String)
            let email = String(decoding: data!, as: UTF8.self)
            print("User's email is:\(email)")
        } catch {
            print(error)
        }
       
        
        if firebaseManager.checkUserLogin() {
            return .loggedIn
        }
        return .loggedOut
    }
    
    
    
    
    func signUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        //register to firebase auth
        firebaseManager.signupUser(email: email, password: password) { error in
            completionHandler(error)
            
            //register in keychain - password
            do {
                try self.keychainManager.addToKeychain(data: password.data(using: .utf8)!, service: "dispatcher.moveo", account: "currentUserPassword", secClass: kSecClassGenericPassword as String) {
                    //completion handler code
                }
            } catch {
                print(error)
            }
            
            //register in keychain - email
            do {
                try self.keychainManager.addToKeychain(data: Data(email.utf8), service: "dispatcher.moveo", account: "currentUserEmail", secClass: kSecClassGenericPassword as String) {
                    //completion handler code
                }
            } catch {
                print(error)
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
                completionHandler(errorDescription)
            } else {
                completionHandler(error)
            }
        }
    }
}
