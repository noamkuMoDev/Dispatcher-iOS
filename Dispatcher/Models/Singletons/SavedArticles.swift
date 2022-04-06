import Foundation

class SavedArticles {
    
    private init() {}
    static var shared = SavedArticles()
    var savedArticlesArray: [FavoriteArticle] = []

//    var savedArticles: [FavoriteArticle] {
//        get {
//            return savedArticlesArray
//        }
//
//        set {
//            savedArticlesArray = newValue
//        }
    }
