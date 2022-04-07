import Foundation

class UserDefaultsManager: NSObject {
    
    let defaults = UserDefaults.standard
    
    override init() {
        super.init()
    }
    
    func checkIfKeyExists(key: String) -> Bool {
        return defaults.object(forKey: key) != nil
    }
    
    
    
    
    func getIntFromUserDefaults(key: String) -> Int {
        let data = defaults.integer(forKey: key)
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
}
