import Foundation

class BaseArticlesViewModel {
    
    private let repository = BaseArticlesRepository()
    
    private var currentPaginationPage = 1
    private var totalPaginationPages = 1
    
    var savedArticles: [String:FavoriteArticle] = [:]
    var newsArray: [Article] = []
    
    
    func fetchNewsFromAPI(searchWords: String = "news", pageSizeToFetch: PageSizeForFetching, completionHandler: @escaping (String?) -> ()) {
        
        repository.fetchNewsFromAPI(searchWords: searchWords, pageSizeType: pageSizeToFetch, savedArticles: savedArticles, currentPage: currentPaginationPage) { articles, totalPages, statusMsg in
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
    
    
    func getSavedArticles(completionHandler: @escaping () -> ()) {
        repository.getSavedArticles() { articlesArray in
            self.savedArticles = articlesArray
            completionHandler()
        }
    }
    
    
    func getUserAppSetting(of settingName: String) -> SwitchStatus {
        return repository.getUserAppSetting(of: settingName)
    }
    
    
    func addArticleToFavorites(_ article: Article, completionHandler: @escaping (String?) -> ()) {
        // update CoreData & Firestore
        repository.saveArticleToFavorites(article) { error, newFavorite in
            if let error = error {
                completionHandler(error)
            } else {
                //add to local favorites array & newsArray
                self.savedArticles[article.id] = newFavorite
                if let index = self.newsArray.firstIndex(where: { $0.id == article.id }) {
                    self.newsArray[index].isFavorite = true
                    completionHandler(nil)
                }
            }
        }
    }
    
    
    func removeArticleFromFavorites(articleID: String, completionHandler: @escaping (String?) -> ()) {
        // remove from CoreData & Firestore
        repository.removeArticleFromFavorites(withID: articleID, from: savedArticles.map({$0.value})) { error in
            if let error = error {
                completionHandler(error)
            } else {
                // remove from local favorites & newsArray
                self.savedArticles.removeValue(forKey: articleID)
                if let index = self.newsArray.firstIndex(where: {$0.id == articleID}) {
                    self.newsArray[index].isFavorite = false
                }
                completionHandler(nil)
            }
        }
    }
}
