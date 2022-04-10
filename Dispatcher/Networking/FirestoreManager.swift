import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager {
    
    let database = Firestore.firestore()
    
    func saveUserToFirestore(uid:String, email:String, userName: String, completionHandler: @escaping (String?) -> ()) {
        self.database.collection("Users").document(uid).setData([
            "email": email,
            "name": userName
        ]) { error in
            if let error = error {
                completionHandler("Error writing document in firestore: \(error)")
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func saveDataIntoCollection(uid: String, data: FavoriteArticle, completionHandler: @escaping (String?) -> ()) {
        
        do {
            try database.collection("Users").document(uid).setData(from: data)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
        
        database.collection("Users").document(uid).collection("savedArticles").document(data.id!).setData([
            "author" : data.author,
            "content" : data.content,
            "date" : data.date,
            "imageUrl": data.imageUrl,
            "isFavorite" : true,
            "title" : data.title,
            "topic" : data.topic,
            "url" : data.url
        ]) { error in
            if let error = error {
                completionHandler("Error writing document in firestore: \(error)")
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func fetchCurrentUserDetails(uid:String, completionHandler: @escaping (String?,[String : Any]?) -> ()) {

        let docRef = database.collection("Users").document(uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let documentValue = document.data()
                completionHandler(nil, documentValue)
            } else {
                completionHandler("Document does not exist", nil)
            }
        }
    }
    
    
    func fetchUserDataCollection(uid: String, completionHandler: @escaping(String?,[String : FavoriteArticle]?) -> ()) {
        
        let docRef = database.collection("Users").document(uid).collection("savedArticles")
        docRef.getDocuments(source: FavoriteArticle.self) { (querySnapshot, error) in
            if let error = error {
                completionHandler("Error getting documents: \(error)",nil)
            } else {
                var resultsDictionary: [String: FavoriteArticle] = [:]
                for document in querySnapshot!.documents {
                    resultsDictionary[document.documentID] = document.data()
                }
                completionHandler(nil,resultsDictionary)
            }
        }
    }
    
    
    func removeDataFromCollection(uid: String, articleID: String, completionHandler: @escaping(String?) -> ()) {
        print(uid)
        print(articleID)
        database.collection("Users").document(uid).collection("savedArticles").document(articleID).delete() { error in
            if let error = error {
                print("encountered error!")
                completionHandler("Error removing document from collection: \(error)")
            } else {
                completionHandler(nil)
            }
        }
    }
}
