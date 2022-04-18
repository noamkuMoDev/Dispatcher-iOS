import Foundation

class SettingsViewModel {
    
    let repository = SettingsRepository()

    var appSettings1 : [SettingModel] = [
    
        SettingModel(
            sectionTitle: Constants.AppSettingsSectionTitles.SEARCH, // search results
            options: [
                SingleSetting (
                    title: Constants.AppSettings.SEARCH_RESULTS, // save search results
                    description: "Allow us to save your search result preferences for next search",
                    status: .off,
                    index: 0
                ),
                SingleSetting (
                    title: Constants.AppSettings.SAVE_FILTERS, // save filters
                    description: "Allow us to save filters when entering back to the app",
                    status: .off,
                    index: 1
                )
            ]
        ),
        
        SettingModel(
            sectionTitle: Constants.AppSettingsSectionTitles.PREFERENCES, // app prefrences
            options: [
                SingleSetting (
                    title: Constants.AppSettings.NOTIFICATION, // notifiactions
                    description: "",
                    status: .on,
                    index: 0
                )
            ]
        )
    
    ]
    
    
    func getUserSettingsPreferences() {
        appSettings1[0].options[1].status = repository.getSaveFiltersSetting()
        appSettings1[0].options[0].status = repository.getSaveSearchResultsSetting()
        appSettings1[1].options[0].status = repository.getNotificationsSetting()
    }
    
    
    func updateSetting(settingTitle:String, settingText: String, completionHandler: @escaping (Int, Int) -> ()) {
        
        var sectionIndex = 0
        if settingTitle == Constants.AppSettings.NOTIFICATION {
            sectionIndex = 1
        }
        
        var rowIndex = 0
        for (i,item) in appSettings1[sectionIndex].options.enumerated() {
            if item.title == settingText {
                rowIndex = i
            }
        }
        
        let currentStatus = appSettings1[sectionIndex].options[rowIndex].status
        var newStatus: SwitchStatus = .off
        if currentStatus != .disabled {
            if currentStatus == .on {
                appSettings1[sectionIndex].options[rowIndex].status = newStatus
            } else {
                newStatus = .on
                appSettings1[sectionIndex].options[rowIndex].status = newStatus
            }
            
            repository.updateSavedSetting(settingTitle: settingTitle, newStatus: newStatus) {
                completionHandler(sectionIndex, rowIndex)
            }
        }
    }
}
