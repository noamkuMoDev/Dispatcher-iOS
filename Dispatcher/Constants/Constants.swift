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
        static let goToSettings = "goToSettings"
    }
    
    struct TableCellsIdentifier {
        static let notification = "notificationCell"
        static let favorites = "savedArticleCell"
        static let homepage = "newsCell"
        static let profileOption = "ProfileOptionCell"
        static let setting = "AppSettingCell"
        static let settingSection = "SettingSectionCell"
        static let recentSearch = "RecentSearchCell"
    }
    
    struct NibNames {
        static let homepage = "NewsCell"
        static let favorites = "SavedArticleCell"
        static let notification = "NotificationCell"
        static let profileOption = "ProfileOptionCell"
        static let appSetting = "AppSettingCell"
        static let appSettingSection = "SettingSectionCell"
        static let recentSearch = "RecentSearchCell"
    }
    
    struct UserDefaults {
        static let recentSearches = "recentSearches"
    }
    
    struct apiCalls {
        static let newsUrl = "https://api.newscatcherapi.com/v2/search"
    }
    
    struct pageSizeToFetch {
        static let savedArticles = 10
        static let articlesList = 7
    }
    
    struct Keys {
        static let newsApiKey = "_E1saiwKuTTM_aofezdXNrGCZsgavQ89t-bJ8Z6WlXA"
    }
}
