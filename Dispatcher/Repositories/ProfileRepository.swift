import Foundation

class ProfileRepository {
    
    let firebaseManager = FirebaseAuthManager()
    
    func logoutUserFromApp(completionHandler: @escaping (String?) -> ()) {
        firebaseManager.logoutUser() { error in
            return completionHandler(error)
        }
    }
}
