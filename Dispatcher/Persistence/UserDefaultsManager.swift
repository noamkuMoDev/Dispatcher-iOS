import Foundation

class UserDefaultsManager: NSObject {
    
    let defaults = UserDefaults.standard
    
    override init() {
        super.init()
    }
    
    
    // 11/4/22 V
    func checkIfKeyExists(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    
    // 11/4/22 V
    func getFromUserDefaults(key: String) -> Any? {
        let data = defaults.object(forKey: key)
        return data
    }

    
    // 11/4/22 V
    func getArrayFromUserDefaults<T>(key: String) -> [T]? {
        if let dataArray = defaults.array(forKey: key) as? [T] {
            return dataArray
        }
        return nil
    }
    
    
    // 11/4/22 V
    func setItemToUserDefaults<T>(key: String, data: T) {
        defaults.set(data, forKey: key)
    }
    
    // 11/4/22 V
    func setArrayToUserDefaults<T>(key: String, dataArray: [T]) {
        defaults.set(dataArray, forKey: key)
    }
    
    
    // 11/4/22 V
    func clearUserDefaultsMemory(keysToRemove: [String]) {
        for keyName in keysToRemove {
            defaults.removeObject(forKey: keyName)
        }
    }
}
