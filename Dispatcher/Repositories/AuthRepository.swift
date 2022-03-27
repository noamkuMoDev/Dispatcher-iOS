import Foundation

class AuthRepository {
    
    func signUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        FirebaseAuthManager().signupUser(email: email, password: password) { error in
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
                completionHandler(error)
            }
        }
    }
}
