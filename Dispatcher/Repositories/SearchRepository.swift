import Foundation

class SearchRepository {
    
    let userDefaults = UserDefaultsManager()
    
    func fetchNewsFromAPI(searchWords: String, currentPage: Int, completionHandler: @escaping (Result<ArticleResponse,Error>,String?) -> ()) {
        
        let url: String = "\(Constants.apiCalls.newsUrl)?q=\(searchWords)&page_size=\(Constants.pageSizeToFetch.articlesList)&page=\(currentPage)"
        let alamofireQuery = AlamofireManager(from: url)
        if !alamofireQuery.isPaginating {
            alamofireQuery.executeGetQuery() {
                ( response: Result<ArticleResponse,Error>, statusMsg ) in
                completionHandler(response, statusMsg)
            }
        }
    }
    
    func fetchSavedRecentSearchesFromUserDefaults() -> [String]? {
        return userDefaults.fetchArrayFromUserDefaults(key: Constants.UserDefaults.recentSearches)
    }

    func updateModelArrayIntoUserDefaults(recentSearchesArr: [RecentSearchModel]) {
        var stringsRecentSearches: [String] = []
        for search in recentSearchesArr {
            stringsRecentSearches.append(search.text)
        }
        userDefaults.setArrayToUserDefaults(key: Constants.UserDefaults.recentSearches, dataArray: stringsRecentSearches)
    }
}
