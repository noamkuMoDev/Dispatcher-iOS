import Foundation

class HomepageRepository {
    
    func fetchNewsFromAPI(currentPage: Int, completionHandler: @escaping (ArticleResponse?, String?) -> ()) {
        
        let url: String = "\(Constants.apiCalls.newsUrl)?q=news&page_size=\(Constants.pageSizeToFetch.articlesList)&page=\(currentPage)"
        let alamofireQuery = AlamofireManager(from: url)
        if !alamofireQuery.isPaginating {
            alamofireQuery.executeGetQuery() {
                ( response: Result<ArticleResponse,Error>, statusMsg ) in
                
                switch response {
                case .success(let dataResult):
                    completionHandler(dataResult, statusMsg) // (ArticleResponse, nil)
                case .failure(let error):
                    completionHandler(nil, error.localizedDescription) // (nil, errorText)
                }
            }
        }
    }
    
}
