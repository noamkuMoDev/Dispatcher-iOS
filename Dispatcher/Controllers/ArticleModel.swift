import Foundation

struct ArticleModel: Decodable, Encodable {
    
    let totalPages: Int
    let articles: [Articles]
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case articles = "articles"
    }
}

struct Articles: Decodable, Encodable {
    
    let id: String
    let articleTitle: String
    let date: String
    let url: String
    let content: String
    let author: String?
    let topic: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case articleTitle = "title"
        case content = "summary"
        case author = "author"
        case url = "link"
        case date = "published_date"
        case topic = "topic"
    }
}

