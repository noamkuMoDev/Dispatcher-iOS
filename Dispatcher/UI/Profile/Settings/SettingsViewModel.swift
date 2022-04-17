import Foundation

class SettingsViewModel {
    
    let repository = SettingsRepository()

    var appSettings: [String:SettingModel] = [
        Constants.AppSettingsSectionTitles.SEARCH: SettingModel(
            sectionTitle: Constants.AppSettingsSectionTitles.SEARCH,
            options: [
                Constants.AppSettings.SEARCH_RESULTS: SingleSetting (
                    title: Constants.AppSettings.SEARCH_RESULTS,
                    description: "Allow us to save your search result preferences for next search",
                    status: .off,
                    index: 0
                ),
                Constants.AppSettings.SAVE_FILTERS: SingleSetting (
                    title: Constants.AppSettings.SAVE_FILTERS,
                    description: "Allow us to save filters when entering back to the app",
                    status: .off,
                    index: 1
                )
            ]
        ),
        Constants.AppSettingsSectionTitles.PREFERENCES: SettingModel(
            sectionTitle: Constants.AppSettingsSectionTitles.PREFERENCES,
            options: [
                Constants.AppSettings.NOTIFICATION: SingleSetting (
                    title: Constants.AppSettings.NOTIFICATION,
                    description: "",
                    status: .on,
                    index: 0
                )
            ]
        )
    ]
    
    var sectionsSortedKeys: [Int: String] = [
        0: Constants.AppSettingsSectionTitles.SEARCH,
        1: Constants.AppSettingsSectionTitles.PREFERENCES
    ]
    
    
    func getUserSettingsPreferences() {
        appSettings[Constants.AppSettingsSectionTitles.SEARCH]?.options[Constants.AppSettings.SAVE_FILTERS]?.status = repository.getSaveFiltersSetting()
        appSettings[Constants.AppSettingsSectionTitles.SEARCH]?.options[Constants.AppSettings.SEARCH_RESULTS]?.status = repository.getSaveSearchResultsSetting()
        appSettings[Constants.AppSettingsSectionTitles.PREFERENCES]?.options[Constants.AppSettings.NOTIFICATION]?.status = repository.getNotificationsSetting()
    }
    
    
    func updateSetting(settingTitle: String, completionHandler: @escaping (Int?, Int?) -> ()) {
        
        var sectionTitle: String? = nil
        var sectionIndex: Int? = nil
        if appSettings[Constants.AppSettingsSectionTitles.SEARCH]?.options[settingTitle] != nil {
            sectionTitle = Constants.AppSettingsSectionTitles.SEARCH
            sectionIndex = 0
        } else if appSettings[Constants.AppSettingsSectionTitles.PREFERENCES]?.options[settingTitle] != nil {
            sectionTitle = Constants.AppSettingsSectionTitles.PREFERENCES
            sectionIndex = 1
        }
        
        if let sectionTitle = sectionTitle {
            let currentStatus = appSettings[sectionTitle]?.options[settingTitle]?.status
            var newStatus: SwitchStatus = .off
            if currentStatus != .disabled {
                if currentStatus == .on {
                    appSettings[sectionTitle]?.options[settingTitle]?.status = newStatus // update local array
                } else {
                    newStatus = .on
                    appSettings[sectionTitle]?.options[settingTitle]?.status = newStatus // update local array
                }
                
                let settingIndex = appSettings[sectionTitle]?.options[settingTitle]?.index
                
                repository.updateSavedSetting(settingTitle: settingTitle, newStatus: newStatus) {
                    completionHandler(sectionIndex, settingIndex)
                }
            }
        }
    }
}
