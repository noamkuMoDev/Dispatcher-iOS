import Foundation

class SignupRepository {
    
    func signUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        FirebaseAuthManager().signupUser(email: email, password: password) { error in
            completionHandler(error)
        }
    }
}
