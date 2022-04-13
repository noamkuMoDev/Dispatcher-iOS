import Foundation

struct Constants {
    
    struct ScreenNames {
        static let HOMEPAGE = "Homepage"
        static let PROFILE = "Profile"
        static let FAVORITES = "Favorites"
        static let SETTINGS = "Setting"
        static let PRIVACY = "Terms & privacy"
        static let LOGOUT = "Logout"
    }
    
    struct ButtonsText {
        static let LOGIN = "LOGIN"
        static let SIGNUP = "SIGNUP"
        static let LOGOUT = "LOGOUT"
    }
    
    struct TextFieldsIDs {
        static let EMAIL = "email"
        static let PASSWORD = "password"
        static let PASSWORD_AGAIN = "re-password"
    }
    
    struct Segues {
        static let HOMEPAGE_TO_NOTIFICATIONS = "homepageToNotifications"
        static let HOMEPAGE_TO_SEARCH = "homepageToSearch"
        static let FAVORITES_TO_NOTIFICATIONS = "favoritesToNotifications"
        static let FAVORITES_TO_SEARCH = "favoritesToSearch"
        static let GO_TO_UPDATE_PROFILE = "goToUpdateProfile"
        static let GO_TO_TERMS_AND_PRIVACY = "goToTermsAndPrivacy"
        static let GO_TO_SETTINGS = "goToSettings"
        static let SPLASH_TO_AUTH = "splashToAuth"
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
    
    struct AppSettingsSectionTitles {
        static let SEARCH = "Search results"
        static let PREFERENCES = "App preferences"
    }
    
    struct AppSettings {
        static let SAVE_FILTERS = "Save filters"
        static let SEARCH_RESULTS = "Save search results"
        static let NOTIFICATION = "Notification"
    }
    
    struct NotificationCenter {
        static let homepageToFavorites = "favoritesChangedInHomepageNotif"
        static let favoritesToHomepage = "favoritesChangedInFavoritesNotif"
    }
    
    struct UserDefaults {
        static let RECENT_SEARCHES = "recentSearches"
        static let SAVE_FILTERS = "saveFilters"
        static let SAVE_SEARCH_RESULTS = "saveSearchResults"
        static let SEND_NOTIFICATIONS = "sendNotifications"
        
        static let CURRENT_USER_UID = "currentUserUID"
        static let CURRENT_USER_NAME = "currentUserName"
        static let CURRENT_USER_IMAGE = "currentUserImage"
        
        static let userDefaultKeys = ["CURRENT_USER_UID","RECENT_SEARCHES","SAVE_FILTERS","SAVE_SEARCH_RESULTS","SEND_NOTIFICATIONS","CURRENT_USER_NAME", "CURRENT_USER_IMAGE"]
    }
    
    struct Keychain {
        static let SERVICE = "dispatcher.moveo"
        static let ACCOUNT_USER_EMAIL = "currentUserEmail"
    }
    
    struct Firestore {
        static let USERS_COLLECTION = "Users"
        static let FAVORITES_COLLECTION = "savedArticles"
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
