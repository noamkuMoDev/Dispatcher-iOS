import Foundation

enum KeychainError: Error {
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    case unexpectedStatus(OSStatus)
}

class KeychainManager {

    // 11/4/22 V
    func fetchFromKeychain(service: String, account: String, secClass: String) throws -> Data? {

        let query: [String: AnyObject] = [
                kSecReturnData as String: kCFBooleanTrue,
                kSecAttrService as String: service as AnyObject,
                kSecAttrAccount as String: account as AnyObject,
                kSecClass as String: secClass as AnyObject,
                kSecMatchLimit as String: kSecMatchLimitOne,
            ]

            var itemCopy: AnyObject?
            let status = SecItemCopyMatching( query as CFDictionary, &itemCopy )

            guard status != errSecItemNotFound else {
                throw KeychainError.itemNotFound
            }
            guard status == errSecSuccess else {
                throw KeychainError.unexpectedStatus(status)
            }
            guard let data = itemCopy as? Data else {
                throw KeychainError.invalidItemFormat
            }

            return data
    }
    
    
    // 11/4/22 V
    func addToKeychain(data: Data, service: String, account: String, secClass: String, completionHandler: @escaping () -> ()) throws {
        
        let query: [String: AnyObject] = [
            kSecValueData as String: data as AnyObject,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: secClass as AnyObject,
        ]

        let status = SecItemAdd( query as CFDictionary, nil )
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateItem
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        completionHandler()
    }

    
    // 11/4/22 V
    func removeFromKeychain(service: String, account: String, secClass: String, completionHandler: @escaping () -> ()) throws {
        
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: secClass as AnyObject
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        completionHandler()
    }
}
