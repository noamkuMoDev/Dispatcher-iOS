import Foundation

class ProfileRepository : AuthRepository {
    
    func logoutUserFromApp(completionHandler: @escaping (String?) -> ()) {
        firebaseManager.logoutUser() { error in
            return completionHandler(error)
        }
    }
}
