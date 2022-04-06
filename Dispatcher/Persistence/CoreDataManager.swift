import UIKit
import CoreData

class CoreDataManager {
    
    let savedArticlesSingleton = SavedArticlesArray.shared
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    func saveItemToCoreData(article: Article, completionHandler: @escaping (String?, FavoriteArticle?) -> ()) {
        let favorite = adaptArticleToFavoriteArticle(article: article)
        if let error = saveCoreDataChanges() {
            completionHandler(error,nil)
        } else {
            completionHandler(nil,favorite)
        }
    }
    
    
    func fetchFavoritesArrayFromCoreData() -> [FavoriteArticle] {
        
        let request: NSFetchRequest<FavoriteArticle> = FavoriteArticle.fetchRequest()
        do {
            let favoritesArray = try context.fetch(request)
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
        if index != -1 {
            context.delete(savedArticlesSingleton.savedArticlesArray[index])
            if let error = saveCoreDataChanges() {
                completionHandler(error)
            } else {
                savedArticlesSingleton.savedArticlesArray.remove(at: index)
                completionHandler(nil)
            }
        } else {
            completionHandler("couldn't find article id in saved articles array")
        }
    }
    
    
    
    private func saveCoreDataChanges() -> String? {
        do {
            try context.save()
            return nil
        } catch {
            return("Error saving context, \(error.localizedDescription)")
        }
    }
    
    
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
