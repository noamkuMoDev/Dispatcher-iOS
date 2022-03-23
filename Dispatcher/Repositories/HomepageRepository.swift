import Foundation

class HomepageRepository {
    
    func fetchNewsFromAPI(currentPage: Int, completionHandler: @escaping (Result<ArticleResponse,Error>,String?) -> ()) {
        
        let url: String = "\(Constants.apiCalls.newsUrl)?q=news&page_size=\(Constants.pageSizeToFetch.articlesList)&page=\(currentPage)"
        let alamofireQuery = AlamofireManager(from: url)
        if !alamofireQuery.isPaginating {
            alamofireQuery.executeGetQuery() {
                ( response: Result<ArticleResponse,Error>, statusMsg ) in
                completionHandler(response, statusMsg)
            }
        }
    }
    
}
