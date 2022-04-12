import Foundation

class SettingsViewModel {
    
    let repository = SettingsRepository()

    var appSettings: [String:SettingModel] = [
        Constants.AppSettingsSectionTitles.SEARCH: SettingModel(
            sectionTitle: Constants.AppSettingsSectionTitles.SEARCH,
            options: [
                Constants.AppSettings.SAVE_FILTERS: SingleSetting (
                    title: Constants.AppSettings.SAVE_FILTERS,
                    description: "Allow us to save filters when entering back to the app",
                    status: .off
                ),
                Constants.AppSettings.SEARCH_RESULTS: SingleSetting (
                    title: Constants.AppSettings.SEARCH_RESULTS,
                    description: "Allow us to save your search result preferences for next search",
                    status: .off
                )
            ]
        ),
        Constants.AppSettingsSectionTitles.PREFERENCES: SettingModel(
            sectionTitle: Constants.AppSettingsSectionTitles.PREFERENCES,
            options: [
                Constants.AppSettings.NOTIFICATION: SingleSetting (
                    title: Constants.AppSettings.NOTIFICATION,
                    status: .on
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
    
    
    func updateSetting(settingTitle: String, completionHandler: @escaping () -> ()) {
        
        var sectionTitle: String? = nil
        if appSettings[Constants.AppSettingsSectionTitles.SEARCH]?.options[settingTitle] != nil {
            sectionTitle = Constants.AppSettingsSectionTitles.SEARCH
        } else if appSettings[Constants.AppSettingsSectionTitles.PREFERENCES]?.options[settingTitle] != nil {
            sectionTitle = Constants.AppSettingsSectionTitles.PREFERENCES
        }
        
        if let sectionTitle = sectionTitle {
            let currentStatus = appSettings[sectionTitle]?.options[settingTitle]?.status
            var newStatus: SwitchStatus = .off
            if currentStatus != .disabled {
                if currentStatus == .on {
                    appSettings[sectionTitle]?.options[settingTitle]?.status = newStatus
                } else {
                    newStatus = .on
                    appSettings[sectionTitle]?.options[settingTitle]?.status = newStatus
                }
                
                repository.updateSavedSetting(settingTitle: settingTitle, newStatus: newStatus) {
                    completionHandler()
                }
            }
        }
    }
}
