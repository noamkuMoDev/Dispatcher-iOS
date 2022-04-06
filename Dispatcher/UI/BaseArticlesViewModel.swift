import Foundation

class BaseArticlesViewModel {
    
    private let repository = BaseArticlesRepository()
    let savedArticlesSingleton = SavedArticles.shared
    
    var newsArray: [Article] = []
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    
    func fetchNewsFromAPI(searchWords: String = "news", pageSizeToFetch: PageSizeForFetching, completionHandler: @escaping (String?) -> ()) {
        
        repository.fetchNewsFromAPI(searchWords: searchWords, pageSizeType: pageSizeToFetch, currentPage: currentPaginationPage) { articles, totalPages, statusMsg in
            if statusMsg == nil {
                self.currentPaginationPage += 1
                if let totalPages = totalPages {
                    self.totalPaginationPages = totalPages
                }
                self.newsArray.append(contentsOf: articles!)
                completionHandler(nil)
            } else {
                completionHandler(statusMsg)
            }
        }
    }
    
    
    func fetchSavedArticles(completionHandler: @escaping () -> ()) {
        repository.fetchSavedArticles() { articlesArray in
            self.savedArticlesSingleton.savedArticlesArray = articlesArray  // put into the singleton
            completionHandler()
        }
    }
    
    
    func addArticleToFavorites(_ article: Article, completionHandler: @escaping () -> ()) {
        repository.saveArticleToFavorites(article) { error in
            if let error = error {
                print(error)
            } else {
                if let index = self.newsArray.firstIndex(where: { $0.id == article.id }) {
                    self.newsArray[index].isFavorite = true
                    completionHandler()
                }
            }
        }
    }
    
    func removeArticleFromFavorites(articleID: String, completionHandler: @escaping (String?) -> ()) {
        print("removeArticleFromFavorites in VM")
        repository.removeArticleFromFavorites(withID: articleID) { error in
            if let error = error {
                completionHandler(error)
            } else {
                if let index = self.newsArray.firstIndex(where: {$0.id == articleID}) {
                    self.newsArray[index].isFavorite = false
                }
                completionHandler(nil)
            }
        }
    }
}
