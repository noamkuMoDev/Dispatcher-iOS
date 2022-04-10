import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager {
    
    let firestoreManager = FirestoreManager()
    let database = Firestore.firestore()
    
    func getCurrentUserUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    // SIGNUP FLOW - V
    func signupUser(email: String, password: String, completionHandler: @escaping (String?, String?, String?) -> ()) {
        print("FIREBASE STARTING TO WORK - AUTH")
        Auth.auth().createUser(withEmail: email, password: password) {
            authResult, error in
            if let error = error {
                completionHandler(error.localizedDescription, nil, nil)
            } else {
                print("AUTH succedded. Registerign in db")
                let uid = authResult!.user.uid
                let userName = email[...email.firstIndex(of: "@")!]
                self.firestoreManager.saveUserToFirestore(uid: uid, email: email, userName: String(userName)) { error in
                    if let error = error {
                        completionHandler(error, nil, nil)
                    } else {
                        completionHandler(nil, String(userName), uid)
                    }
                }
            }
        }
    }
    
    
    // LOGIN FLOW - V
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    // LOGIN FLOW - V
    func loginUser(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completionHandler(error.localizedDescription)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    
    // LOGUOT FLOW - V
    func logoutUser(completionHandler: @escaping (String?) -> ()) {
        do {
            try Auth.auth().signOut()
            completionHandler(nil)
        } catch (let error) {
            completionHandler(error.localizedDescription)
        }
    }
}
