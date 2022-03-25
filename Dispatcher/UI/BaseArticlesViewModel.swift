import Foundation

class BaseArticlesViewModel {
    
    private let repository = BaseArticlesRepository()
    
    var newsArray: [Article] = []
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    
    func fetchNewsFromAPI(searchWords: String = "news", pageSizeToFetch: PageSizeForFetching, completionHandler: @escaping (String?) -> ()) {
        
        repository.fetchNewsFromAPI(searchWords: searchWords, pageSizeType: pageSizeToFetch, currentPage: currentPaginationPage) { result, statusMsg in
            if statusMsg == nil {
                self.currentPaginationPage += 1
                self.totalPaginationPages = result!.totalPages
                self.newsArray.append(contentsOf: result!.articles)
                completionHandler(nil)
            } else {
                completionHandler(statusMsg)
            }
        }
    }
}
