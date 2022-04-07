import Foundation

class SearchRepository: BaseArticlesRepository {
    
    let userDefaults = UserDefaultsManager()
    
    func getSavedRecentSearchesFromUserDefaults() -> [String]? {
        return userDefaults.getArrayFromUserDefaults(key: Constants.UserDefaults.RECENT_SEARCHES)
    }
    
    func updateModelArrayIntoUserDefaults(recentSearchesArr: [RecentSearchModel]) {
        var stringsRecentSearches: [String] = []
        for search in recentSearchesArr {
            stringsRecentSearches.append(search.text)
        }
        userDefaults.setArrayToUserDefaults(key: Constants.UserDefaults.RECENT_SEARCHES, dataArray: stringsRecentSearches)
    }
}
