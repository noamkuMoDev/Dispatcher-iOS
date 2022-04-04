import Foundation

class ProfileViewModel {
    
    var repository = ProfileRepository()
    
    var optionsArray: [ProfileOptionModel] = [
        ProfileOptionModel(icon: "gearWheel", text: "Setting", navigateTo: Constants.Segues.GO_TO_SETTINGS),
        ProfileOptionModel(icon: "documents", text: "Terms & privacy", navigateTo: Constants.Segues.GO_TO_TERMS_AND_PRIVACY),
        ProfileOptionModel(icon: "logout", text: "Logout")
    ]
    
    func logUserOut(completionHandler: @escaping (String?) -> ()) {
        repository.logoutUserFromApp() { error in
            completionHandler(error)
        }
    }
}
