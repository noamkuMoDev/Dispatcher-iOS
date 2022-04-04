import Foundation

class SettingsRepository {
    
    let userDefaultsManager = UserDefaultsManager()
    
    func updateSavedSetting(settingsArray: [SettingModel], settingTitle: String, modelIndex: Int, settingIndex: Int , completionHandler: @escaping () -> ()) {
        
        var key: String = ""
        var data: String = ""
        switch settingTitle {
        case "Save filters":
            key = Constants.UserDefaults.SAVE_FILTERS
        case "Save search results":
            key = Constants.UserDefaults.SAVE_SEARCH_RESULTS
        case "Notification":
            key = Constants.UserDefaults.SEND_NOTIFICATIONS
        default:
            print("not valid option")
        }
        userDefaultsManager.setItemToUserDefaults(key: key, data: settingsArray[modelIndex].options[settingIndex].status)
 
        completionHandler()
    }
}
