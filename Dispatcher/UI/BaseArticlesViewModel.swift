import Foundation

class BaseArticlesViewModel {
    
    private let repository = BaseArticlesRepository()
    
    let savedArticlesSingleton = SavedArticlesArray.shared
    let news = ArticlesArray.shared
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    
    func fetchNewsFromAPI(searchWords: String = "news", pageSizeToFetch: PageSizeForFetching, completionHandler: @escaping (String?) -> ()) {
        
        repository.fetchNewsFromAPI(searchWords: searchWords, pageSizeType: pageSizeToFetch, currentPage: currentPaginationPage) { articles, totalPages, statusMsg in
            if statusMsg == nil {
                self.currentPaginationPage += 1
                if let totalPages = totalPages {
                    self.totalPaginationPages = totalPages
                }
                self.news.newsArray.append(contentsOf: articles!)
                completionHandler(nil)
            } else {
                completionHandler(statusMsg)
            }
        }
    }
    
    
    func fetchSavedArticles(completionHandler: @escaping () -> ()) {
        repository.getSavedArticles() { articlesArray in
            self.savedArticlesSingleton.savedArticlesArray = articlesArray
            completionHandler()
        }
    }
    
    
    func addArticleToFavorites(_ article: Article, completionHandler: @escaping (String?) -> ()) {
        repository.saveArticleToFavorites(article) { error in
            if let error = error {
                completionHandler(error)
            } else {
                if let index = self.news.newsArray.firstIndex(where: { $0.id == article.id }) {
                    self.news.newsArray[index].isFavorite = true
                    completionHandler(nil)
                }
            }
        }
    }
    
    
    func removeArticleFromFavorites(articleID: String, completionHandler: @escaping (String?) -> ()) {
        repository.removeArticleFromFavorites(withID: articleID) { error in
            if let error = error {
                completionHandler(error)
            } else {
                if let index = self.news.newsArray.firstIndex(where: {$0.id == articleID}) {
                    self.news.newsArray[index].isFavorite = false
                }
                completionHandler(nil)
            }
        }
    }
}
