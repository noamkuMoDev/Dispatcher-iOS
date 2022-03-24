import Foundation

class UserDefaultsManager: NSObject {
    
    let defaults = UserDefaults.standard
    
    override init() {
        super.init()
    }
    
    func fetchArrayFromUserDefaults<T>(key: String) -> [T]? {
        if let dataArray = defaults.array(forKey: key) as? [T] {
            return dataArray
        }
        return nil
    }
    
    func setArrayToUserDefaults<T>(key: String, dataArray: [T]) {
        defaults.set(dataArray, forKey: key)
    }
}
