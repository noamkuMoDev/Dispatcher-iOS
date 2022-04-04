import Foundation

class ProfileRepository {
    
    let firebaseManager = FirebaseAuthManager()
    let keychainManager = KeychainManager()
    
    func logoutUserFromApp(completionHandler: @escaping (String?) -> ()) {
        firebaseManager.logoutUser() { error in
            return completionHandler(error)
        }
        
        //remove from keychain - password
        do {
            try keychainManager.removeFromKeychain(service: "dispatcher.moveo", account: "currentUserPassword", secClass: kSecClassGenericPassword as String) {
                
            }
        } catch {
            print(error)
        }
        
        //remove from keychain - email
        do {
            try keychainManager.removeFromKeychain(service: "dispatcher.moveo", account: "currentUserEmail", secClass: kSecClassGenericPassword as String) {
                
            }
        } catch {
            print(error)
        }
    }
}
