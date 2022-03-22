import Foundation

class HomepageViewModel {
    
    var newsArray: [Articles] = []
    
    private var currentPaginationPage = 1
    private var amountToFetch = 7
    private var totalPaginationPages = 1
    
    func fetchNewsFromAPI(completionHandler: @escaping () -> ()) {
        
        let alamofireQuery = AlamofireManager(from: "\(Constants.apiCalls.newsUrl)?q=news&page_size=\(amountToFetch)&page=\(currentPaginationPage)")
        
        if !alamofireQuery.isPaginating && currentPaginationPage <= totalPaginationPages {
            alamofireQuery.executeGetQuery(){
                (result: Result<ArticleModel,Error>, statusMsg) in
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
}
