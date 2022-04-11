import Foundation

class SearchViewModel: BaseArticlesViewModel {
    
    let repository = SearchRepository()
    
    var recentSearchesArray: [RecentSearchModel] = []
    
    func isSaveRecentSearches() -> Bool {
        switch repository.getUserAppSetting(of: Constants.UserDefaults.SAVE_SEARCH_RESULTS) {
        case .disabled:
            return false
        case .on:
            return true
        case .off:
            return false
        }
    }
    
    // 11/4/22 V
    func getSavedRecentSearchesFromUserDefaults(completionHandler: @escaping (String?) -> ()) {
        if let recentSearches = repository.getSavedRecentSearchesFromUserDefaults() {
            for search in recentSearches {
                recentSearchesArray.append(RecentSearchModel(text: search))
                completionHandler(nil)
            }
        } else {
            completionHandler("Couldn't get search history")
        }
    }
    
    
    // 11/4/22 V
    func saveNewRecentSearch(_ keyword: String, completionHandler: @escaping () -> ()) {
        
        if !recentSearchesArray.contains(where: {$0.text == keyword}) {
            recentSearchesArray.insert(RecentSearchModel(text: keyword), at: 0)
            
            if recentSearchesArray.count > 10 {
                recentSearchesArray.remove(at: recentSearchesArray.count-1)
            }
            
            repository.updateRecentSearchesInUserDefaults(recentSearchesArr: recentSearchesArray)
        }
        completionHandler()
    }
    
    
    // 11/4/22 V
    func updateRecentSearchesHistoryOrder(selectedSearch: String, completionHandler: @escaping () -> ()) {
        let index = recentSearchesArray.firstIndex(where: { $0.text == selectedSearch })!
        recentSearchesArray.insert(recentSearchesArray[index], at: 0)
        recentSearchesArray.remove(at: index+1)
        repository.updateRecentSearchesInUserDefaults(recentSearchesArr: recentSearchesArray)
        completionHandler()
    }
    
    
    // 11/4/22 V
    func removeItemFromRecentSearchesHistory(searchToRemove: String, completionHandler: @escaping () -> ()) {
        recentSearchesArray = recentSearchesArray.filter { $0.text !=  searchToRemove}
        repository.updateRecentSearchesInUserDefaults(recentSearchesArr: recentSearchesArray)
        completionHandler()
    }
    
    
    
    // 11/4/22 V
    func clearRecentSearchesHistory(completionHandler: @escaping () -> ()) {
        recentSearchesArray = []
        repository.updateRecentSearchesInUserDefaults(recentSearchesArr: recentSearchesArray)
        completionHandler()
    }
}
