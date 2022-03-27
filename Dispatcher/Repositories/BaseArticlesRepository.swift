import Foundation

enum PageSizeForFetching {
    case articlesList
    case savedArticles
}

class BaseArticlesRepository {
    
    func fetchNewsFromAPI(searchWords: String, pageSizeType: PageSizeForFetching, currentPage: Int, completionHandler: @escaping (ArticleResponse?, String?) -> ()) {
        var pageSize: Int
        switch pageSizeType {
        case .articlesList:
            pageSize = Constants.pageSizeToFetch.ARTICLES_LIST
        case .savedArticles:
            pageSize = Constants.pageSizeToFetch.SAVED_ARTICLES
        }
        
        let url: String = "\(Constants.apiCalls.NEWS_URL)?q=\(searchWords)&page_size=\(pageSize)&page=\(currentPage)"
        let alamofireQuery = AlamofireManager(from: url)
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
