import Foundation

class AppSettings {
    
    let userDefaultsManager = UserDefaultsManager()
    
    private init() {}
    
    static var shared = AppSettings()
    
    var notificationsEnabled : SwitchStatus {
        get {
            userDefaultsManager.fetchBoolFromUserDefaults(key: <#T##String#>)
        }
        
        set {
            
        }
    }
}
