import Foundation

class ProfileRepository: AuthRepository {
    
    let coreDataManager = FavoriteArticleCoreDataManager()
    
    // 11/4/22 V
    func fetchUserData(with key: String) -> Any? {
        return userDefaultsManager.getFromUserDefaults(key: key)
    }
    
    
    // 11/4/22 V
    func logoutUserFromApp(completionHandler: @escaping (String?) -> ()) {
        do {
            try keychainManager.removeFromKeychain(
                service: Constants.Keychain.SERVICE,
                account: Constants.Keychain.ACCOUNT_USER_EMAIL,
                secClass: kSecClassGenericPassword as String
            ) {
                self.firebaseAuthManager.logoutUser() { error in
                    if let error = error {
                        completionHandler("Error logging out from firebase: \(error)")
                    } else {
                        self.coreDataManager.clearCoreDataMemory()
                        self.userDefaultsManager.clearUserDefaultsMemory(keysToRemove: Constants.UserDefaults.userDefaultKeys)
                        completionHandler(nil)
                    }
                }
            }
        } catch {
            completionHandler("Error in deleting from keychain: \(error.localizedDescription)")
        }
    }
}
