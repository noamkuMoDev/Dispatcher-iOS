import Foundation

class ProfileViewModel {
    
    var optionsArray: [ProfileOptionModel] = [
        ProfileOptionModel(icon: "gearWheel", text: "Setting", navigateTo: Constants.Segues.goToSettings),
        ProfileOptionModel(icon: "documents", text: "Terms & privacy", navigateTo: Constants.Segues.goToTermsAndPrivacy),
        ProfileOptionModel(icon: "logout", text: "Logout")
    ]
}
