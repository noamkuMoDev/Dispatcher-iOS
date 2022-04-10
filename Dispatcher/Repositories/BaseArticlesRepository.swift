import UIKit
import CoreData

enum PageSizeForFetching {
    case articlesList
    case savedArticles
}

class BaseArticlesRepository {
    
    let userDefaultsManager = UserDefaultsManager()
    let coreDataManager = CoreDataManager()
    let firestoreManager = FirestoreManager()
    
    func fetchNewsFromAPI(searchWords: String, pageSizeType: PageSizeForFetching, savedArticles:[String:FavoriteArticle], currentPage: Int, completionHandler: @escaping ([Article]?,Int?, String?) -> ()) {
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
                        
                        if savedArticles[article.id] != nil {
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
    

    func getSavedArticles(completionHandler: @escaping ([String:FavoriteArticle]) -> ()) {
        
        // check CoreData for savedArticles
        let favoritesArray = coreDataManager.fetchFavoritesArrayFromCoreData()
        if favoritesArray.count != 0 { // found
            var favoritesDictionary: [String:FavoriteArticle] = [:]
            for article in favoritesArray {
                favoritesDictionary[article.id!] = article
            }
            completionHandler(favoritesDictionary)
        } else { // nothing on CoreData
            print("NOTHING ON CORE DATA")
            // fetch Firestore
            let uid = userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.CURRENT_USER_UID)
            if uid == nil {
                print("Couldn't get current user uid to fetch saved articles")
                completionHandler([:])
            } else {
                print("FETCH FROM FIRESTORE")
                firestoreManager.fetchUserDataCollection(uid: uid as! String) { error, savedArticles in
                    if error != nil {
                        completionHandler([:])
                    } else {
                        // !!!!!! TO DO : save to CoreData !!!!!!!
                        print(savedArticles)
                        completionHandler(savedArticles! as! [String:FavoriteArticle])
                    }
                }
            }
        }
    }
    
    
    func saveArticleToFavorites(_ article: Article, completionHandler: @escaping (String?,FavoriteArticle?) -> ()) {
        // add to CoreData
        coreDataManager.saveItemToCoreData(article: article) { (error, favoriteArticle) in
            if let error = error {
                completionHandler(error, nil)
            } else {
                // add to Firestore
                let uid = self.userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.CURRENT_USER_UID)
                if uid != nil {
                    self.firestoreManager.saveDataIntoCollection(uid: uid as! String, data: favoriteArticle!) { error in
                        if let error = error {
                            completionHandler("error saving into user's collection in firestore: \(error)",nil)
                        } else {
                            // update local arrays
                            completionHandler(nil, favoriteArticle)
                        }
                    }
                } else {
                    completionHandler("couldn't get user uid",nil)
                }
            }
        }
    }
    
    
    func removeArticleFromFavorites(withID articleID: String, from savedArticles: [FavoriteArticle], completionHandler: @escaping (String?) -> ()) {
        // remove from CoreData
        coreDataManager.deleteFromCoreData(removeID: articleID, savedArticles: savedArticles) { error in
            if let error = error {
                completionHandler(error)
            } else {
                // remove from Firestore
                let uid = self.userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.CURRENT_USER_UID)
                if uid != nil {
                    self.firestoreManager.removeDataFromCollection(uid: uid as! String, articleID: articleID) { error in
                        if let error = error {
                            completionHandler("error removing from firestore: \(error)")
                        } else {
                            // update local arrays
                            completionHandler(nil)
                        }
                    }
                } else {
                    completionHandler("couldn't get user uid")
                }
            }
        }
    }
    
    
    // HOMEPAGE FLOW - V
    func getUserAppSetting(of settingName: String) -> SwitchStatus {
        
        var status: SwitchStatus = .off
        switch settingName {
        case Constants.UserDefaults.SAVE_SEARCH_RESULTS:
            status = SwitchStatus(rawValue: userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.SAVE_SEARCH_RESULTS) as! Int) ?? .off
        case Constants.UserDefaults.SAVE_FILTERS:
            status = SwitchStatus(rawValue: userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.SAVE_FILTERS) as! Int) ?? .off
        case Constants.UserDefaults.SEND_NOTIFICATIONS:
            status = SwitchStatus(rawValue: userDefaultsManager.getFromUserDefaults(key: Constants.UserDefaults.SEND_NOTIFICATIONS) as! Int) ?? .off
        default:
            print("invalid option")
        }
        return status
    }
}
