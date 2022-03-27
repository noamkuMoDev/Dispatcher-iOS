import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    
    func signupUser(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            
            if error != nil {
                // error creating user
                completionHandler(error?.localizedDescription)
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
            
            if error != nil {
                // error signing user
                completionHandler(error?.localizedDescription)
            } else {
                print(authResult!)
                completionHandler(nil)
            }
        }
    }
}
