import Foundation

class ViewProfileRepository {
    
    let userDefaultsManager = UserDefaultsManager()
    let keychainManager = KeychainManager()
    let firestoreManager = FirestoreManager()
    let firebaseAuthManager = FirebaseAuthManager()
    
    
    func getUserUID() -> String? {
        return firebaseAuthManager.getCurrentUserUID()
    }
    
    
    func getUserDetails(completionHandler: @escaping (String?,String?,String?) -> ()) {
        do {
            let userName = userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.CURRENT_USER_NAME) as! String
            let userImage = userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.CURRENT_USER_IMAGE) as? String
            let userEmail = try keychainManager.fetchFromKeychain(
                service: Constants.Keychain.SERVICE,
                account: Constants.Keychain.ACCOUNT_USER_EMAIL,
                secClass: kSecClassGenericPassword as String
            )
            completionHandler(userName, userEmail as? String, userImage)
        } catch (let error) {
            print(error)
        }
        
    }
    
    
    func updateUserDetail(detailType: String, data: String) {
        
        let uid = firebaseAuthManager.getCurrentUserUID()
        if let uid = uid {
            let docPath = "\(Constants.Firestore.USERS_COLLECTION)/\(uid)"
            
            switch detailType {
            case Constants.UserDefaults.CURRENT_USER_NAME:
                firestoreManager.updateDocumentInFirestore(docuemntPath: docPath, property: "name", value: data) { error in
                    if let error = error {
                        print("Faild updating name in Firestore - \(error)")
                    } else {
                        self.userDefaultsManager.setItemToUserDefaults(key: detailType, data: data)
                    }
                }
            case Constants.TextFieldsIDs.USRE_EMAIL:
                firebaseAuthManager.updateUserEmail(to: data) { error in
                    if let error = error {
                        print("Faild updating email in Firebase Auth - \(error)")
                    } else {
                        do {
                            try self.keychainManager.updateInKeychain(
                                data: Data(data.utf8),
                                service: Constants.Keychain.SERVICE,
                                account: Constants.Keychain.ACCOUNT_USER_EMAIL,
                                secClass: kSecClassGenericPassword as String
                            ){
                                
                            }
                        } catch (let error) {
                            print("Error updating keychain - \(error)")
                        }
                    }
                }
            case Constants.UserDefaults.CURRENT_USER_IMAGE:
                firestoreManager.updateDocumentInFirestore(docuemntPath: docPath, property: "image", value: data) { error in
                    if let error = error {
                        print("Faild updating image in Firestore - \(error)")
                    } else {
                        self.userDefaultsManager.setItemToUserDefaults(key: detailType, data: data)
                    }
                }
            default:
                print("invalide option")
            }
            
        } else {
            print("couldn't get current user's uid")
        }
    }
}
