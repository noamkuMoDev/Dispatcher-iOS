import Foundation

struct Constants {
    
    struct ScreenNames {
        static let homepage = "Homepage"
        static let profile = "Profile"
        static let favorites = "Favorites"
    }
    
    struct Segues {
        static let homepageToNotifications = "homepageToNotifications"
        static let homepageToSearch = "homepageToSearch"
        static let favoritesToNotifications = "favoritesToNotifications"
        static let favoritesToSearch = "favoritesToSearch"
        static let goToUpdateProfile = "goToUpdateProfile"
        static let goToTermsAndPrivacy = "goToTermsAndPrivacy"
    }
    
    struct TableCellsIdentifier {
        static let notification = "notificationCell"
        static let favorites = "savedArticleCell"
        static let homepage = "newsCell"
    }
    
    struct NibNames {
        static let homepage = "NewsCell"
        static let favorites = "SavedArticleCell"
        static let notification = "NotificationCell"
    }
}
