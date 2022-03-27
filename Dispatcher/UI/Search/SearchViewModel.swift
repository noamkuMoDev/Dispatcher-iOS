import Foundation

class SearchViewModel: BaseArticlesViewModel {
    
    let repository = SearchRepository()
    
    var recentSearchesArray: [RecentSearchModel] = []
    
    
    func fetchSavedRecentSearchesFromUserDefaults(completionHandler: @escaping (String?) -> ()) {
        if let recentSearches = repository.fetchSavedRecentSearchesFromUserDefaults() {
            for search in recentSearches {
                recentSearchesArray.append(RecentSearchModel(text: search))
                completionHandler(nil)
            }
        } else {
            completionHandler("couldn't fetch search history")
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
    
    func updateRecentSearchesHistoryOrder(selectedSearch: String, completionHandler: @escaping () -> ()) {
        let index = recentSearchesArray.firstIndex(where: { $0.text == selectedSearch })!
        recentSearchesArray.insert(recentSearchesArray[index], at: 0)
        recentSearchesArray.remove(at: index+1)
        repository.updateModelArrayIntoUserDefaults(recentSearchesArr: recentSearchesArray)
        completionHandler()
    }
    
    func removeItemFromRecentSearchesHistory(searchToRemove: String, completionHandler: @escaping () -> ()) {
        recentSearchesArray = recentSearchesArray.filter { $0.text !=  searchToRemove}
        repository.updateModelArrayIntoUserDefaults(recentSearchesArr: recentSearchesArray)
        completionHandler()
    }
}
