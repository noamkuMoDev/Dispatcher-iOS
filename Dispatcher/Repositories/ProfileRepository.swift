import Foundation

class ProfileRepository {
    
    let firebaseManager = FirebaseAuthManager()
    let keychainManager = KeychainManager()
    
    func logoutUserFromApp(completionHandler: @escaping (String?) -> ()) {
        
        do {
            try keychainManager.removeFromKeychain(
                service: Constants.Keychain.SERVICE,
                account: Constants.Keychain.ACCOUNT_USER_EMAIL,
                secClass: kSecClassGenericPassword as String
            ) {
                self.firebaseManager.logoutUser() { error in
                    return completionHandler(error)
                }
            }
        } catch {
            return completionHandler("Error in deleting from keychain: \(error.localizedDescription)")
        }
    }
}
