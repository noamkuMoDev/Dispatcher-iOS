import Foundation

class SearchRepository: BaseArticlesRepository {
    
    let userDefaults = UserDefaultsManager()
    
    // 11/4/22 V
    func getSavedRecentSearchesFromUserDefaults() -> [String]? {
        return userDefaults.getArrayFromUserDefaults(key: Constants.UserDefaults.RECENT_SEARCHES)
    }
    
    
    // 11/4/22 V
    func updateRecentSearchesInUserDefaults(recentSearchesArr: [RecentSearchModel]) {
        var recentSearchesStringsArray: [String] = []
        for search in recentSearchesArr {
            recentSearchesStringsArray.append(search.text)
        }
        userDefaults.setArrayToUserDefaults(key: Constants.UserDefaults.RECENT_SEARCHES, dataArray: recentSearchesStringsArray)
    }
}
