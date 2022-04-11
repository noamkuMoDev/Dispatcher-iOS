import Foundation

class BaseArticlesViewModel {
    
    private let repository = BaseArticlesRepository()
    
    var savedArticles: [String:FavoriteArticle] = [:]
    var newsArray: [Article] = []
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    
    // 11/4/22 V
    func fetchNewsFromAPI(searchWords: String = "news", pageSizeToFetch: PageSizeForFetching, completionHandler: @escaping (String?) -> ()) {
        repository.fetchNewsFromAPI(searchWords: searchWords, pageSizeType: pageSizeToFetch, savedArticles: savedArticles, currentPage: currentPaginationPage) {
            articles, totalPages, statusMsg in
            
            if let statusMsg = statusMsg {
                self.newsArray = []
                completionHandler(statusMsg)
            } else {
                self.currentPaginationPage += 1
                if let totalPages = totalPages {
                    self.totalPaginationPages = totalPages
                }
                self.newsArray.append(contentsOf: articles!)
                completionHandler(nil)
            }
        }
    }
    
    // 11/4/22 V
    func getSavedArticles(completionHandler: @escaping () -> ()) {
        repository.getSavedArticles() { articlesArray in
            self.savedArticles = articlesArray
            completionHandler()
        }
    }
    
    // 11/4/22 V
    func getUserAppSetting(of settingName: String) -> SwitchStatus {
        return repository.getUserAppSetting(of: settingName)
    }
    
    // 11/4/22 V
    func addArticleToFavorites(_ article: Article, completionHandler: @escaping (String?) -> ()) {
        repository.saveArticleToFavorites(article) { error, newFavorite in
            if let error = error {
                completionHandler(error)
            } else {
                self.savedArticles[article.id] = newFavorite
                if let index = self.newsArray.firstIndex(where: { $0.id == article.id }) {
                    self.newsArray[index].isFavorite = true
                    completionHandler(nil)
                }
            }
        }
    }
    
    // 11/4/22 V
    func removeArticleFromFavorites(articleID: String, completionHandler: @escaping (String?) -> ()) {
        repository.removeArticleFromFavorites(withID: articleID, from: savedArticles.map({$0.value})) { error in
            if let error = error {
                completionHandler(error)
            } else {
                self.updateArticleToNotFavoriteLocally(articleID: articleID)
                completionHandler(nil)
            }
        }
    }
    
    
    // 11/4/22 V
    func updateArticleToNotFavoriteLocally(articleID: String) {
        self.savedArticles[articleID] = nil
        if let index = self.newsArray.firstIndex(where: {$0.id == articleID}) {
            self.newsArray[index].isFavorite = false
        }
    }
}
