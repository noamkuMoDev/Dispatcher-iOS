import Foundation

class ProfileViewModel {
    
    var optionsArray: [ProfileOptionModel] = [
        ProfileOptionModel(icon: "gearWheel", text: "Setting", navigateTo: Constants.Segues.GO_TO_SETTINGS),
        ProfileOptionModel(icon: "documents", text: "Terms & privacy", navigateTo: Constants.Segues.GO_TO_TERMS_AND_PRIVACY),
        ProfileOptionModel(icon: "logout", text: "Logout")
    ]
}