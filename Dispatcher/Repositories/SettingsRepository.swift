import Foundation

class SettingsRepository {
    
    let appSettings = AppSettings.shared
    
    func fetchNotificationsSetting() -> SwitchStatus {
        return appSettings.notificationsEnabled
    }
    
    func fetchSaveFiltersSetting() -> SwitchStatus {
        return appSettings.saveFilters
    }
    
    func fetchSaveSearchResultsSetting() -> SwitchStatus {
        return appSettings.saveSearchResults
    }
    
    
    func updateSavedSetting(settingTitle: String, newStatus: SwitchStatus, completionHandler: @escaping () -> ()) {

        switch settingTitle {
        case "Save filters":
            appSettings.saveFilters = newStatus
        case "Save search results":
            appSettings.saveSearchResults = newStatus
        case "Notification":
            appSettings.notificationsEnabled = newStatus
        default:
            print("not valid option")
        }
        completionHandler()
    }
}
