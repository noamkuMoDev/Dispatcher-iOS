import Foundation

class SavedArticlesArray {
    
    private init() {}
    static var shared = SavedArticlesArray()
    var savedArticlesArray: [FavoriteArticle] = []
    
}
