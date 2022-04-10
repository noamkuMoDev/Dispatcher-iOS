import Foundation

class SettingsRepository {
    
    let userDefaultsManager = UserDefaultsManager()
    
    func getNotificationsSetting() -> SwitchStatus {
       return SwitchStatus(rawValue: userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.SEND_NOTIFICATIONS) as! Int) ?? .off
    }
    
    func getSaveFiltersSetting() -> SwitchStatus {
        return SwitchStatus(rawValue: userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.SAVE_FILTERS) as! Int) ?? .off
    }
    
    func getSaveSearchResultsSetting() -> SwitchStatus {
        return SwitchStatus(rawValue: userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.SAVE_SEARCH_RESULTS) as! Int) ?? .off
    }
    
    
    func updateSavedSetting(settingTitle: String, newStatus: SwitchStatus, completionHandler: @escaping () -> ()) {

        switch settingTitle {
        case "Save filters":
            userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SAVE_FILTERS, data: newStatus.rawValue)
        case "Save search results":
            userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SAVE_SEARCH_RESULTS, data: newStatus.rawValue)
        case "Notification":
            userDefaultsManager.setItemToUserDefaults(key: Constants.UserDefaults.SEND_NOTIFICATIONS, data: newStatus.rawValue)
        default:
            print("not valid option")
        }
        completionHandler()
    }
}
