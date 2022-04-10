import Foundation

class ProfileRepository {
    
    let firebaseManager = FirebaseAuthManager()
    let keychainManager = KeychainManager()
    let coreDataManager = CoreDataManager()
    let userDefaultsManager = UserDefaultsManager()
    
    // LOGOUT FLOW - V
    func logoutUserFromApp(completionHandler: @escaping (String?) -> ()) {

        do {
            try keychainManager.removeFromKeychain(
                service: Constants.Keychain.SERVICE,
                account: Constants.Keychain.ACCOUNT_USER_EMAIL,
                secClass: kSecClassGenericPassword as String
            ) {
                self.firebaseManager.logoutUser() { error in

                    self.coreDataManager.clearCoreDataMemory()
                    
                    let userDefaultsKeysToRemove = [
                        Constants.UserDefaults.CURRENT_USER_UID,
                        Constants.UserDefaults.CURRENT_USER_NAME,
                        Constants.UserDefaults.RECENT_SEARCHES,
                        Constants.UserDefaults.SAVE_FILTERS,
                        Constants.UserDefaults.SEND_NOTIFICATIONS,
                        Constants.UserDefaults.SAVE_SEARCH_RESULTS
                    ]
                    self.userDefaultsManager.clearUserDefaultsMemory(keysToRemove: userDefaultsKeysToRemove)
                    
                    return completionHandler(error)
                }
            }
        } catch {
            return completionHandler("Error in deleting from keychain: \(error.localizedDescription)")
        }
    }
}
