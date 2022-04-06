import UIKit
import CoreData

class CoreDataManager {
    
    let savedArticlesSingleton = SavedArticles.shared
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // v
    func saveItemToCoreData(article: Article, completionHandler: @escaping (String?) -> ()) {
        _ = adaptArticleToFavoriteArticle(article: article)
        if let error = saveCoreDataChanges() {
            completionHandler(error)
        } else {
            print("saved all good")
            completionHandler(nil)
        }
    }
    
    
    // v
    func fetchFavoritesArrayFromCoreData() -> [FavoriteArticle] {
        
        let request: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        do {
            let favoritesArray = try context.fetch(request)
//            var articles: [Article] = []
//            for article in favoritesArray {
//                articles.append(Article(id: article.id!, articleTitle: article.title!, date: article.date!, url: article.url!, content: article.content!, author: article.author, topic: article.topic!, imageUrl: article.imageUrl, isFavorite: article.isFavorite))
//            }
            return favoritesArray
        } catch {
            print("Error fetching data from context, \(error)")
        }
        return []
    }
    
    
    func deleteFromCoreData(removeID: String, completionHandler: @escaping (String?) -> ()) {

        var index: Int = -1
        for (i,item) in savedArticlesSingleton.savedArticlesArray.enumerated() {
            if item.id == removeID {
                index = i
            }
        }
        context.delete(savedArticlesSingleton.savedArticlesArray[index])
        if let error = saveCoreDataChanges() {
            completionHandler(error)
        } else {
            print("deleted all good")
            savedArticlesSingleton.savedArticlesArray.remove(at: index)
            completionHandler(nil)
        }
    }
    
    
    // v
    private func saveCoreDataChanges() -> String? {
        do {
            try context.save()
            return nil
        } catch {
            return("Error saving context, \(error.localizedDescription)")
        }
    }
    
    // v
    private func adaptArticleToFavoriteArticle(article: Article) -> FavoriteArticle {
        
        let favoriteArticle = FavoriteArticle(context: context)
        favoriteArticle.id = article.id
        favoriteArticle.isFavorite = article.isFavorite
        favoriteArticle.imageUrl = article.imageUrl
        favoriteArticle.topic = article.topic
        favoriteArticle.author = article.author
        favoriteArticle.content = article.content
        favoriteArticle.url = article.url
        favoriteArticle.date = article.date
        favoriteArticle.title = article.articleTitle
        
        return favoriteArticle
    }
}
