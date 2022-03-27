import Foundation

struct ArticleResponse: Codable {
    
    let totalPages: Int
    let articles: [Article]
    let numOfResults: Int
    
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case articles = "articles"
        case numOfResults = "total_hits"
    }
}
