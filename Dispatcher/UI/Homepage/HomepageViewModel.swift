import Foundation

class HomepageViewModel {
    
    private let repository = HomepageRepository()
    var newsArray: [Article] = []
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    func fetchNewsFromAPI(completionHandler: @escaping (String?) -> ()) {
        
        repository.fetchNewsFromAPI(currentPage: currentPaginationPage) { result, statusMsg in
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
