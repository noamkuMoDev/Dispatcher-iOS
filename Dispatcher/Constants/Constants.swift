import Foundation

struct Constants {
    
    struct ScreenNames {
        static let HOMEPAGE = "Homepage"
        static let PROFILE = "Profile"
        static let FAVORITES = "Favorites"
    }
    
    struct Segues {
        static let HOMEPAGE_TO_NOTIFICATIONS = "homepageToNotifications"
        static let HOMEPAGE_TO_SEARCH = "homepageToSearch"
        static let FAVORITES_TO_NOTIFICATIONS = "favoritesToNotifications"
        static let FAVORITES_TO_SEARCH = "favoritesToSearch"
        static let GO_TO_UPDATE_PROFILE = "goToUpdateProfile"
        static let GO_TO_TERMS_AND_PRIVACY = "goToTermsAndPrivacy"
        static let GO_TO_SETTINGS = "goToSettings"
    }
    
    struct TableCellsIdentifier {
        static let NOTIFICATION = "notificationCell"
        static let FAVORITES = "savedArticleCell"
        static let HOMEPAGE = "newsCell"
        static let PROFILE_OPTION = "ProfileOptionCell"
        static let SETTING = "AppSettingCell"
        static let SETTING_SECTION = "SettingSectionCell"
        static let RECENT_SEARCH = "RecentSearchCell"
    }
    
    struct NibNames {
        static let HOMEPAGE = "NewsCell"
        static let FAVORITES = "SavedArticleCell"
        static let NOTIFICATION = "NotificationCell"
        static let PROFILE_OPTION = "ProfileOptionCell"
        static let APP_SETTING = "AppSettingCell"
        static let APP_SETTING_SECTION = "SettingSectionCell"
        static let RECENT_SEARCH = "RecentSearchCell"
    }
    
    struct UserDefaults {
        static let RECENT_SEARCHES = "recentSearches"
    }
    
    struct apiCalls {
        static let NEWS_URL = "https://api.newscatcherapi.com/v2/search"
    }
    
    struct pageSizeToFetch {
        static let SAVED_ARTICLES = 10
        static let ARTICLES_LIST = 7
    }
    
    struct Keys {
        static let NEWS_API_KEY = "_E1saiwKuTTM_aofezdXNrGCZsgavQ89t-bJ8Z6WlXA"
    }
}
