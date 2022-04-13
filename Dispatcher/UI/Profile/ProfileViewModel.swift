import Foundation

class ProfileViewModel {
    
    let repository = ProfileRepository()
    
    var optionsArray: [ProfileOptionModel] = [
        ProfileOptionModel(icon: "gearWheel", text: Constants.ScreenNames.SETTINGS, navigateTo: Constants.Segues.GO_TO_SETTINGS),
        ProfileOptionModel(icon: "documents", text: Constants.ScreenNames.PRIVACY, navigateTo: Constants.Segues.GO_TO_TERMS_AND_PRIVACY),
        ProfileOptionModel(icon: "logout", text: Constants.ScreenNames.LOGOUT)
    ]

    
    func fetchUserData(dataKey: String) -> Any? {
        return repository.fetchUserData(with: dataKey)
    }

    
    func logUserOut(completionHandler: @escaping (String?) -> ()) {
        repository.logoutUserFromApp() { error in
            completionHandler(error)
        }
    }
}
