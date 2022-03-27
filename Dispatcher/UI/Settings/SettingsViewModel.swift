import Foundation

class SettingsViewModel {
    
    var appSettings: [SettingModel] = [
        SettingModel(sectionTitle: "Search results", options: [
            SingleSetting(title: "Save filters", description: "Allow us to save filters when entering back to the app", status: .off),
            SingleSetting(title: "Save search results", description: "Allow us to save your search result preferences for next search", status: .off)
        ]),
        SettingModel(sectionTitle: "App preferences", options: [
            SingleSetting(title: "Notification", status: .on)
        ]),
    ]
}
