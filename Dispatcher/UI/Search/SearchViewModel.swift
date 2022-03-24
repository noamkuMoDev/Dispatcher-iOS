import Foundation

class SearchViewModel {
    
    let repository = SearchRepository()
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    var recentSearchesArray: [RecentSearchModel] = []
    var searchResultsArray: [Article] = []
    
    
    func fetchNewsFromAPI(searchWords: String, completionHandler: @escaping (String?) -> ()) {
        
        if currentPaginationPage <= totalPaginationPages {
            repository.fetchNewsFromAPI(searchWords: searchWords, currentPage: currentPaginationPage) { result, statusMsg in

                if statusMsg == nil {
                    self.currentPaginationPage += 1
                    self.totalPaginationPages = result!.totalPages
                    self.searchResultsArray.append(contentsOf: result!.articles)
                    completionHandler(nil)
                } else {
                    completionHandler(statusMsg!)
                }
            }
        }
    }
    
    func fetchSavedRecentSearchesFromUserDefaults() {
        if let recentSearches = repository.fetchSavedRecentSearchesFromUserDefaults() {
            for search in recentSearches {
                recentSearchesArray.append(RecentSearchModel(text: search))
            }
        } else {
            print("couldn't fetch search history")
        }
    }
    
    func clearRecentSearchesHistory(completionHandler: @escaping () -> ()) {
        recentSearchesArray = []
        repository.updateModelArrayIntoUserDefaults(recentSearchesArr: recentSearchesArray)
        completionHandler()
    }
    
    func saveNewRecentSearch(_ keyword: String, completionHandler: @escaping () -> ()) {
        
        if !recentSearchesArray.contains(where: {$0.text == keyword}) {
            recentSearchesArray.insert(RecentSearchModel(text: keyword), at: 0)
            
            if recentSearchesArray.count > 10 {
                recentSearchesArray.remove(at: recentSearchesArray.count-1)
            }
            
            repository.updateModelArrayIntoUserDefaults(recentSearchesArr: recentSearchesArray)
        }
        completionHandler()
    }
    
    func updateRecentSearchesHistoryOrder(selectedSearch: String) {
        let index = recentSearchesArray.firstIndex(where: { $0.text == selectedSearch })!
        recentSearchesArray.insert(recentSearchesArray[index], at: 0)
        recentSearchesArray.remove(at: index+1)
        repository.updateModelArrayIntoUserDefaults(recentSearchesArr: recentSearchesArray)
    }
    
    func removeItemFromRecentSearchesHistory(searchToRemove: String, completionHandler: @escaping () -> ()) {
        recentSearchesArray = recentSearchesArray.filter { $0.text !=  searchToRemove}
        repository.updateModelArrayIntoUserDefaults(recentSearchesArr: recentSearchesArray)
        completionHandler()
    }
}
