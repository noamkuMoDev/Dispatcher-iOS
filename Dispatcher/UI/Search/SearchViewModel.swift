import Foundation

class SearchViewModel {
    
    private var currentPaginationPage = 1
    private var amountToFetch = 7
    private var totalPaginationPages = 1
    
    var recentSearchesArray: [RecentSearchModel] = []
    var searchResultsArray: [Articles] = []
    
    let defaults = UserDefaults.standard
    
    
    func fetchNewsFromAPI(query:String = "news", completionHandler: @escaping (String) -> ()) {
        
        let alamofireQuery = AlamofireManager(from: "\(Constants.apiCalls.newsUrl)?q=\(query)&page_size=\(amountToFetch)&page=\(currentPaginationPage)")
        
        if !alamofireQuery.isPaginating && currentPaginationPage <= totalPaginationPages {
            alamofireQuery.executeGetQuery() {
                ( result: Result<ArticleModel,Error>, statusMsg ) in
                switch result {
                case .success(let response):
                    self.currentPaginationPage += 1
                    self.totalPaginationPages = response.totalPages
                    self.searchResultsArray.append(contentsOf: response.articles)
                case .failure(let error):
                    print(error)
                }
                completionHandler(statusMsg)
            }
        }
    }
    
    func clearRecentSearchesHistory(completionHandler: @escaping () -> ()) {
        recentSearchesArray = []
        updateModelArrayIntoUserDefaults()
        completionHandler()
    }
    
    func fetchSavedRecentSearchesFromUserDefaults() {
        
        if let savedRecentSearches = defaults.array(forKey: Constants.UserDefaults.recentSearches) as? [String] {
            for search in savedRecentSearches {
                recentSearchesArray.append(RecentSearchModel(text: search))
            }
        }
    }
    
    func saveNewRecentSearch(_ keyword: String) {
        
        if !recentSearchesArray.contains(where: {$0.text == keyword}) {
            recentSearchesArray.insert(RecentSearchModel(text: keyword), at: 0)
            
            if recentSearchesArray.count > 10 {
                recentSearchesArray.remove(at: recentSearchesArray.count-1)
            }
            
            updateModelArrayIntoUserDefaults()
        }
    }
    
    func updateRecentSearchesHistoryOrder(selectedSearch: String) {
        let index = recentSearchesArray.firstIndex(where: { $0.text == selectedSearch })!
        recentSearchesArray.insert(recentSearchesArray[index], at: 0)
        recentSearchesArray.remove(at: index+1)
        updateModelArrayIntoUserDefaults()
    }
    
    func updateModelArrayIntoUserDefaults() {
        var stringsRecentSearches: [String] = []
        for search in recentSearchesArray {
            stringsRecentSearches.append(search.text)
        }
        defaults.set(stringsRecentSearches, forKey: Constants.UserDefaults.recentSearches)
    }
    
    func removeItemFromRecentSearchesHistory(searchToRemove: String, completionHandler: @escaping () -> ()) {
        recentSearchesArray = recentSearchesArray.filter { $0.text !=  searchToRemove}
        updateModelArrayIntoUserDefaults()
        completionHandler()
    }
}
