import UIKit
import CoreData

enum PageSizeForFetching {
    case articlesList
    case savedArticles
}

class BaseArticlesRepository {
    
    let userDefaultsManager = UserDefaultsManager()
    let coreDataManager = FavoriteArticleCoreDataManager()
    let firestoreManager = FirestoreManager()
    let firebaseAuthManager = FirebaseAuthManager()
    
    
    // 11/4/22 V
    func fetchNewsFromAPI(searchWords: String, pageSizeType: PageSizeForFetching, savedArticles: [String:FavoriteArticle], currentPage: Int, completionHandler: @escaping ([Article]?, Int?, String?) -> ()) {
        var pageSize: Int
        switch pageSizeType {
        case .articlesList:
            pageSize = Constants.pageSizeToFetch.ARTICLES_LIST
        case .savedArticles:
            pageSize = Constants.pageSizeToFetch.SAVED_ARTICLES
        }
        
        let url = "\(Constants.apiCalls.NEWS_URL)?q=\(searchWords)&page_size=\(pageSize)&page=\(currentPage)"
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
    

    // 11/4/22 V
    func getSavedArticles(completionHandler: @escaping ([String:FavoriteArticle]) -> ()) {
        
        let favoritesArray = coreDataManager.fetchFavoritesArrayFromCoreData()
        if favoritesArray.count != 0 {
            let favoritesDictionary = favoritesArray.reduce(into: [String:FavoriteArticle]()) {
                $0[$1.id!] = $1
            }
            completionHandler(favoritesDictionary)
            
        } else {
            let uid = firebaseAuthManager.getCurrentUserUID()
            if uid == nil {
                print("Error - Couldn't get current user's uid")
                completionHandler([:])
            } else {
                let colPath = "\(Constants.Firestore.USERS_COLLECTION)/\(uid!)/\(Constants.Firestore.FAVORITES_COLLECTION)"
                firestoreManager.fetchCollectionDataFromFirestore(collectionPath: colPath) { error, dataDictionary in
                    if error != nil {
                        print("Error fetching saved articles from firestore")
                        completionHandler([:])
                    } else {
                        var savedArticles: [String: FavoriteArticle] = [:]
                        for item in dataDictionary! as! [String: FavoriteArticle] {
                            let favoriteArticle = FavoriteArticle(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                            favoriteArticle.title =  item.value.title
                            favoriteArticle.isFavorite = item.value.isFavorite
                            favoriteArticle.author = item.value.author
                            favoriteArticle.topic = item.value.topic
                            favoriteArticle.imageUrl = item.value.imageUrl
                            favoriteArticle.content = item.value.content
                            favoriteArticle.url = item.value.url
                            favoriteArticle.date = item.value.date
                            favoriteArticle.id = item.key
                            savedArticles[item.key] = favoriteArticle
                        }

                        self.coreDataManager.saveFavoriteArticlesArrayToCoreData(articles: savedArticles.map({$0.value})) { error in
                            if let error = error {
                                print("Error saving all favorites to CoreData: \(error)")
                            }
                            completionHandler(savedArticles)
                        }
                    }
                }
            }
        }
    }
    
    
    // 11/4/22 V
    func saveArticleToFavorites(_ article: Article, completionHandler: @escaping (String?, FavoriteArticle?) -> ()) {

        coreDataManager.saveArticleToCoreData(article) { error, favoriteArticle in
            if let error = error {
                completionHandler("Error saving article to CoreData: \(error)", nil)
            } else {
                let uid = self.firebaseAuthManager.getCurrentUserUID()
                if uid != nil {
                    let dataDict: [String: Any] = [
                        "author" : article.author ?? "", "content" : article.content,
                        "date" : article.date, "imageUrl": article.imageUrl ?? "",
                        "isFavorite" : true, "title" : article.articleTitle,
                        "topic" : article.topic, "url" : article.url
                    ]
                    let colPath = "\(Constants.Firestore.USERS_COLLECTION)/\(uid!)/\(Constants.Firestore.FAVORITES_COLLECTION)"
                    
                    self.firestoreManager.saveDocumentToFirestore(collectionPath: colPath, customID: article.id, dataDictionary: dataDict) { error in
                        if let error = error {
                            completionHandler("Error saving into user's favorites in firestore: \(error)", nil)
                        } else {
                            completionHandler(nil, favoriteArticle)
                        }
                    }
                } else {
                    completionHandler("Couldn't get current user's uid", nil)
                }
            }
        }
    }
    
    
    // 11/4/22 V
    func removeArticleFromFavorites(withID articleID: String, from savedArticles: [FavoriteArticle], completionHandler: @escaping (String?) -> ()) {
        
        coreDataManager.deleteFromCoreData(removeID: articleID, fromArray: savedArticles) { error in
            if let error = error {
                completionHandler("Error removing from CoreData: \(error)")
            } else {
                let uid = self.firebaseAuthManager.getCurrentUserUID()
                if uid != nil {
                    let docPath = "\(Constants.Firestore.USERS_COLLECTION)/\(uid!)/\(Constants.Firestore.FAVORITES_COLLECTION)/\(articleID)"
                    self.firestoreManager.removeDataFromCollection(documentPath: docPath) { error in
                        if let error = error {
                            completionHandler("Error removing from firestore: \(error)")
                        } else {
                            completionHandler(nil)
                        }
                    }
                } else {
                    completionHandler("Couldn't get current user's uid")
                }
            }
        }
    }
    
    
    // 11/4/22 V
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
