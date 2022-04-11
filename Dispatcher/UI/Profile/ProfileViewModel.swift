import Foundation

class ProfileViewModel {
    
    let repository = ProfileRepository()
    
    var optionsArray: [ProfileOptionModel] = [
        ProfileOptionModel(icon: "gearWheel", text: Constants.ScreenNames.SETTINGS, navigateTo: Constants.Segues.GO_TO_SETTINGS),
        ProfileOptionModel(icon: "documents", text: Constants.ScreenNames.PRIVACY, navigateTo: Constants.Segues.GO_TO_TERMS_AND_PRIVACY),
        ProfileOptionModel(icon: "logout", text: Constants.ScreenNames.LOGOUT)
    ]

    
    // 11/4/22 V
    func fetchUserData(dataKey: String) -> Any? {
        return repository.fetchUserData(with: dataKey)
    }

    
    // 11/4/22 V
    func logUserOut(completionHandler: @escaping (String?) -> ()) {
        repository.logoutUserFromApp() { error in
            completionHandler(error)
        }
    }
}
