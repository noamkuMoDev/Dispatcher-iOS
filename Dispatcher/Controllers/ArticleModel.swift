import Foundation

protocol Article {
    var title: String { get }
    var date: Date { get }
    var content: String { get }
    var url: String { get }
    var isFavorite: Bool { get set }
}

struct ArticleModel: Article {
    var title: String
    var date: Date
    var content: String
    var url: String
    var isFavorite: Bool
}
