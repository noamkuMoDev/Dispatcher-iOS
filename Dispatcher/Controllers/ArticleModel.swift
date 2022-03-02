import Foundation

protocol Article {
    var title: String { get }
    var date: Date { get }
    var url: String { get }
    var isFavorite: Bool { get set }
}

struct ArticleModel: Article {
    var title: String
    var date: Date
    var url: String
    var isFavorite: Bool
    
    var content: String
}

struct VideoModel: Article {
    var title: String
    var date: Date
    var url: String
    var isFavorite: Bool
    
    var length: Float
}
