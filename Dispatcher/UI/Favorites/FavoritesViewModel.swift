import Foundation
import UIKit

class FavoritesViewModel {
    
    let repository = FavoritesRepository()
    
    var newsArray: [Articles] = []
    
    var currentPaginationPage = 1
    var amountToFetch = 10
    var totalPaginationPages = 1
    
    
    func fetchNewsFromAPI(completionHandler: @escaping (String) -> ()) {
        
        if currentPaginationPage <= totalPaginationPages {
            
            let url: String = "\(Constants.apiCalls.newsUrl)?q=news&page_size=\(amountToFetch)&page=\(currentPaginationPage)"
            repository.fetchNewsFromAPI(url: url) { result, statusMsg in
                
                switch result {
                case .success(let response):
                    self.currentPaginationPage += 1
                    self.totalPaginationPages = response.totalPages
                    self.newsArray.append(contentsOf: response.articles)
                    
                case .failure(let error):
                    print(error)
                }
                completionHandler(statusMsg)
            }
        }
    }
}
