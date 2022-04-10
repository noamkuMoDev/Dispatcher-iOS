import UIKit
import CoreData

class CoreDataManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    func saveArticleToCoreData(article: Article, completionHandler: @escaping (String?, FavoriteArticle?) -> ()) {
        let favorite = adaptArticleToFavoriteArticle(article)
        if let error = saveCoreDataChanges() {
            completionHandler(error,nil)
        } else {
            completionHandler(nil,favorite)
        }
    }
    
    func saveFavoriteArticlesArrayToCoreData(articles: [FavoriteArticle], completionHandler: @escaping (String?) -> ()) {
        let error = saveCoreDataChanges()
        completionHandler(error)
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
    
    
    func deleteFromCoreData(removeID: String, savedArticles: [FavoriteArticle], completionHandler: @escaping (String?) -> ()) {

        var index: Int = -1
        for (i,item) in savedArticles.enumerated() {
            if item.id == removeID {
                index = i
            }
        }
        if index != -1 {
            context.delete(savedArticles[index])
            if let error = saveCoreDataChanges() {
                completionHandler(error)
            } else {
                // remove from the local array !!
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
    
    
    private func adaptArticleToFavoriteArticle(_ article: Article) -> FavoriteArticle {
        
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
    
    
    func clearCoreDataMemory() {
        let entities = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel.entities
        for entity in entities {
            delete(entityName: entity.name!)
        }
    }
  
     func delete(entityName: String) {
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
         do {
             try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.execute(deleteRequest)
         } catch let error as NSError {
             debugPrint(error)
         }
     }
}
