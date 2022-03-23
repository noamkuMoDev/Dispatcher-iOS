import Foundation

class HomepageViewModel {
    
    let repository = HomepageRepository()
    var newsArray: [Article] = []
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    func fetchNewsFromAPI(completionHandler: @escaping () -> ()) {
        
        repository.fetchNewsFromAPI(currentPage: currentPaginationPage) { result, statusMsg in
            
                switch result {
                case .success(let response):
                    self.currentPaginationPage += 1
                    self.totalPaginationPages = response.totalPages
                    self.newsArray.append(contentsOf: response.articles)
                case .failure(let error):
                    print(error)
                }
                completionHandler()
            }
        }
    }
