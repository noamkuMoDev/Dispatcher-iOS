import Foundation

class BaseArticlesViewModel {
    
    private let repository = BaseArticlesRepository()
    
    var savedArticles: [String:FavoriteArticle] = [:]
    var newsArray: [Article] = []
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    
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
    

    func getSavedArticles(completionHandler: @escaping () -> ()) {
        repository.getSavedArticles() { articlesArray in
            self.savedArticles = articlesArray
            completionHandler()
        }
    }
    

    func getUserAppSetting(of settingName: String) -> SwitchStatus {
        return repository.getUserAppSetting(of: settingName)
    }
    
    
    func getUserLastLoginTimestamp() -> String? {
        return repository.getUserLastLoginTimestamp()
    }
    

    func addArticleToFavorites(_ article: Article, completionHandler: @escaping (String?) -> ()) {
        repository.saveArticleToFavorites(article) { error, newFavorite in
            if let error = error {
                completionHandler(error)
            } else {
                self.savedArticles[article.id] = newFavorite
                if self.newsArray.count == 0 {
                    completionHandler(nil)
                } else {
                    if let index = self.newsArray.firstIndex(where: { $0.id == article.id }) {
                        self.newsArray[index].isFavorite = true
                        completionHandler(nil)
                    }
                }
            }
        }
    }
    

    func removeArticleFromFavorites(articleID: String, completionHandler: @escaping (String?) -> ()) {
        repository.removeArticleFromFavorites(withID: articleID, from: savedArticles.map({$0.value})) { error in
            if let error = error {
                completionHandler(error)
            } else {
                self.updateArticleToNotFavoriteLocally(articleID: articleID) {
                    completionHandler(nil)
                }
            }
        }
    }
    
    
    func updateArticleToNotFavoriteLocally(articleID: String, completionHandler: @escaping () -> ()) {
        self.savedArticles[articleID] = nil
        if let index = self.newsArray.firstIndex(where: {$0.id == articleID}) {
            self.newsArray[index].isFavorite = false
        }
        completionHandler()
    }
    
    
    func updateArticleToYesFavoriteLocally(articleID: String, completionHandler: @escaping () -> ()) {
        if let index = self.newsArray.firstIndex(where: {$0.id == articleID}) {
            self.newsArray[index].isFavorite = true
            completionHandler()
        }
    }
}
