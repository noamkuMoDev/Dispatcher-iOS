import Foundation
import UIKit

class FavoritesViewModel {
    
    let repository = FavoritesRepository()
    
    var newsArray: [Article] = []
    
    var currentPaginationPage = 1
    var totalPaginationPages = 1
    
    
    func fetchNewsFromAPI(completionHandler: @escaping (String) -> ()) {
        
        if currentPaginationPage <= totalPaginationPages {
            
            repository.fetchNewsFromAPI(currentPage: currentPaginationPage) { result, statusMsg in

                switch result {
                case .success(let response):
                    self.currentPaginationPage += 1
                    self.totalPaginationPages = response.totalPages
                    self.newsArray.append(contentsOf: response.articles)
                    
                case .failure(let error):
                    print(error)
                }
                completionHandler(statusMsg!)
            }
        }
    }
}
