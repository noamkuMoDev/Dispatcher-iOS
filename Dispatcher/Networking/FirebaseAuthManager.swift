import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signupUser(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            
            if let error = error {
                completionHandler(error.localizedDescription)
            } else {
                let uid = authResult!.user.uid
                // TO DO - save the user in a database
                print(uid)
                completionHandler(nil)
            }
        }
    }
    
    func loginUser(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                completionHandler(error.localizedDescription)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func logoutUser(completionHandler: @escaping (String?) -> ()) {
        do {
            try Auth.auth().signOut()
            completionHandler(nil)
        } catch (let error) {
            completionHandler(error.localizedDescription)
        }
    }
}
