import Foundation
import UIKit

class FavoritesViewModel {
    
    let repository = FavoritesRepository()
    
    var newsArray: [Article] = []
    
    var currentPaginationPage = 1
    var totalPaginationPages = 1
    
    
    func fetchNewsFromAPI(completionHandler: @escaping (String?) -> ()) {
        
        if currentPaginationPage <= totalPaginationPages {
            
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
}
