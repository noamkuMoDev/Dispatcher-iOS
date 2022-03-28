import Foundation

enum userType {
    case freshUser
    case loggedOut
    case loggedIn
}

class AuthRepository {
    
    func checkIfLoggedIn() -> userType {
        let userDefaults = UserDefaultsManager()
        
        if !userDefaults.checkIfKeyExists(key: Constants.UserDefaults.IS_USER_LOGGED_IN) {
            return .freshUser
        } else {
            if userDefaults.fetchBoolFromUserDefaults(key: Constants.UserDefaults.IS_USER_LOGGED_IN) {
                return .loggedIn
            } else {
                return .loggedOut
            }
        }
    }
    
    func signUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        FirebaseAuthManager().signupUser(email: email, password: password) { error in
            if error == nil {
                UserDefaultsManager().setItemToUserDefaults(key: Constants.UserDefaults.IS_USER_LOGGED_IN, data: true)
            }
            completionHandler(error)
        }
    }
    
    func logUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        FirebaseAuthManager().loginUser(email: email, password: password) { error in
            var errorDescription = ""
            if error != nil {
                if error!.contains("There is no user record") {
                    errorDescription = "Couldn't find a match to given credentials"
                } else if error!.contains("The password is invalid") {
                    errorDescription = "Incorrect password"
                } else {
                    errorDescription = error!
                }
                completionHandler(errorDescription)
            } else {
                UserDefaultsManager().setItemToUserDefaults(key: Constants.UserDefaults.IS_USER_LOGGED_IN, data: true)
                completionHandler(error)
            }
        }
    }
    
    
    func logoutUserFromApp(completionHandler: @escaping () -> ()) {
        UserDefaultsManager().setItemToUserDefaults(key: Constants.UserDefaults.IS_USER_LOGGED_IN, data: false)
        completionHandler()
    }
}
