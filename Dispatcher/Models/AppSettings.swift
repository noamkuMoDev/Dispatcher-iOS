import Foundation

class AppSettings {
    
    let userDefaultsManager = UserDefaultsManager()
    
    private init() {}
    static var shared = AppSettings()
    
    
    var notificationsEnabled: SwitchStatus {
        get {
            let index = userDefaultsManager.fetchIntFromUserDefaults(key: Constants.UserDefaults.SEND_NOTIFICATIONS)
            return SwitchStatus(rawValue: index) ?? .off
        }
        
        set {
            userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SEND_NOTIFICATIONS, data: newValue.rawValue)
        }
    }
    
    
    var saveFilters: SwitchStatus {
        get {
            let index = userDefaultsManager.fetchIntFromUserDefaults(key: Constants.UserDefaults.SAVE_FILTERS)
            return SwitchStatus(rawValue: index) ?? .off
        }
        
        set {
            userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SAVE_FILTERS, data: newValue.rawValue)
        }
    }
    
    
    var saveSearchResults: SwitchStatus {
        get {
            let index = userDefaultsManager.fetchIntFromUserDefaults(key: Constants.UserDefaults.SAVE_SEARCH_RESULTS)
            return SwitchStatus(rawValue: index) ?? .off
        }
        
        set {
            userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SAVE_SEARCH_RESULTS, data: newValue.rawValue)
        }
    }
}
