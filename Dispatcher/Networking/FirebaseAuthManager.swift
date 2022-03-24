import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    
    func signUserToApp(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            
            if error != nil {
                // there was an error creating the user, dispaly message on screen
                print(error!)
            } else {
                let uid = authResult!.user.uid
                // TO DO - save the user in a database
                print(uid)
            }
        }
    }
}
