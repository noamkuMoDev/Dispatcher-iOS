import Foundation

class FavoritesRepository {
    
    func fetchNewsFromAPI(url: String, completionHandler: @escaping (Result<ArticleModel,Error>,String) -> ()) {
        
        let alamofireQuery = AlamofireManager(from: url)
        if !alamofireQuery.isPaginating {
            alamofireQuery.executeGetQuery() {
                ( result: Result<ArticleModel,Error>, statusMsg ) in
                completionHandler(result, statusMsg)
            }
        }
    }
}
