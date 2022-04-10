import Foundation

class UserDefaultsManager: NSObject {
    
    let defaults = UserDefaults.standard
    
    override init() {
        super.init()
    }
    
    
    func checkIfKeyExists(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    
    
    func getFromUserDefaults(key: String) -> Any? {
        let data = defaults.object(forKey: key)
        return data
    }

    func getArrayFromUserDefaults<T>(key: String) -> [T]? {
        if let dataArray = defaults.array(forKey: key) as? [T] {
            return dataArray
        }
        return nil
    }
    
    
    
    func setItemToUserDefaults<T>(key: String, data: T) {
        defaults.set(data, forKey: key)
    }
    
    func setArrayToUserDefaults<T>(key: String, dataArray: [T]) {
        defaults.set(dataArray, forKey: key)
    }
    
    
    // LOGOUT FLOW - V
    func clearUserDefaultsMemory() {
        //user info
        defaults.removeObject(forKey: Constants.UserDefaults.CURRENT_USER_NAME)
        defaults.removeObject(forKey: Constants.UserDefaults.RECENT_SEARCHES)
        
        //app settings
        defaults.removeObject(forKey: Constants.UserDefaults.SAVE_FILTERS)
        defaults.removeObject(forKey: Constants.UserDefaults.SEND_NOTIFICATIONS)
    }
}
