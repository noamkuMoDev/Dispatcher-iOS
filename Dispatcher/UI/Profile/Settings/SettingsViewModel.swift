import Foundation

class SettingsViewModel {
    
    let repository = SettingsRepository()
    
    var appSettings: [SettingModel] = [
        SettingModel(sectionTitle: "Search results", options: [
            SingleSetting(title: "Save filters", description: "Allow us to save filters when entering back to the app", status: .off),
            SingleSetting(title: "Save search results", description: "Allow us to save your search result preferences for next search", status: .off)
        ]),
        SettingModel(sectionTitle: "App preferences", options: [
            SingleSetting(title: "Notification", status: .on)
        ]),
    ]
    
    func fetchUserSettingsPreferences() {
        appSettings[0].options[0].status = repository.fetchSaveFiltersSetting()
        appSettings[0].options[1].status = repository.fetchSaveSearchResultsSetting()
        appSettings[1].options[0].status = repository.fetchNotificationsSetting()
    }
    
    func updateSetting(settingTitle: String, completionHandler: @escaping () -> ()) {
        var modelIndex = -1
        var settingIndex = -1
        for (i, settingModel) in appSettings.enumerated() {
            for (j, singleSetting) in settingModel.options.enumerated() {
                if singleSetting.title == settingTitle {
                    modelIndex = i
                    settingIndex = j
                }
            }
        }
        let currentStatus = appSettings[modelIndex].options[settingIndex].status
        var newStatus: SwitchStatus = .off
        if currentStatus != .disabled {
            if currentStatus == .on {
                appSettings[modelIndex].options[settingIndex].status = newStatus
            } else {
                newStatus = .on
                appSettings[modelIndex].options[settingIndex].status = newStatus
            }
            
            repository.updateSavedSetting(settingTitle: settingTitle, newStatus: newStatus) {
                completionHandler()
            }
        }
    }
}
