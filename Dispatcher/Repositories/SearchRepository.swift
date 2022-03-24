import Foundation

class SearchRepository {
    
    let userDefaults = UserDefaultsManager()
    
    func fetchNewsFromAPI(searchWords: String, currentPage: Int, completionHandler: @escaping (ArticleResponse?, String?) -> ()) {
        
        let url: String = "\(Constants.apiCalls.NEWS_URL)?q=\(searchWords)&page_size=\(Constants.pageSizeToFetch.ARTICLES_LIST)&page=\(currentPage)"
        let alamofireQuery = AlamofireManager(from: url)
        if !alamofireQuery.isPaginating {
            alamofireQuery.executeGetQuery() {
                ( response: Result<ArticleResponse,Error>, statusMsg ) in
                
                switch response {
                case .success(let dataResult):
                    completionHandler(dataResult, statusMsg) // (ArticleResponse, nil)
                case .failure(let error):
                    completionHandler(nil, error.localizedDescription) // (nil, errorText)
                }
            }
        }
    }
    
    func fetchSavedRecentSearchesFromUserDefaults() -> [String]? {
        return userDefaults.fetchArrayFromUserDefaults(key: Constants.UserDefaults.RECENT_SEARCHES)
    }

    func updateModelArrayIntoUserDefaults(recentSearchesArr: [RecentSearchModel]) {
        var stringsRecentSearches: [String] = []
        for search in recentSearchesArr {
            stringsRecentSearches.append(search.text)
        }
        userDefaults.setArrayToUserDefaults(key: Constants.UserDefaults.RECENT_SEARCHES, dataArray: stringsRecentSearches)
    }
}
