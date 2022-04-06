import UIKit
import CoreData

enum PageSizeForFetching {
    case articlesList
    case savedArticles
}

class BaseArticlesRepository {
    
    let coreDataManager = CoreDataManager()
    let savedArticlesSingleton = SavedArticles.shared
    
    func fetchNewsFromAPI(searchWords: String, pageSizeType: PageSizeForFetching, currentPage: Int, completionHandler: @escaping ([Article]?,Int?, String?) -> ()) {
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
                ( response: Result<ArticleApiObject,Error>, statusMsg ) in
                switch response {
                case .success(let dataResult):
                    
                    var articles: [Article] = []
                    for article in dataResult.articles {
                        var article = Article(id: article.id, articleTitle: article.articleTitle, date: article.date, url: article.url, content: article.content, author: article.author, topic: article.topic, imageUrl: article.imageUrl, isFavorite: false)
                        if self.checkIfArticleInFavorites(article.id) {
                            article.isFavorite = true
                        }
                        articles.append(article)
                    }
                    completionHandler(articles, dataResult.totalPages, statusMsg) // ([Article], totalPages, nil)
                    
                case .failure(let error):
                    completionHandler(nil, nil, error.localizedDescription) // (nil, nil, errorText)
                }
            }
    }
    
    
    func fetchSavedArticles(completionHandler: @escaping ([FavoriteArticle]) -> ()) {
        completionHandler(coreDataManager.fetchFavoritesArrayFromCoreData())
    }
    
    
    func saveArticleToFavorites(_ article: Article, completionHandler: @escaping (String?) -> ()) {
        coreDataManager.saveItemToCoreData(article: article) { error in
            completionHandler(error)
        }
    }
    
    
    func removeArticleFromFavorites(withID articleID: String,completionHandler: @escaping (String?) -> ()) {
        print("removeArticleFromFavorites in REPOSITORY")
        coreDataManager.deleteFromCoreData(removeID: articleID) { error in
            completionHandler(error)
        }
    }
    
    func checkIfArticleInFavorites(_ articleID: String) -> Bool {
        let index = savedArticlesSingleton.savedArticlesArray.firstIndex(where: {$0.id == articleID})
        return index != nil ? true : false
    }
}
