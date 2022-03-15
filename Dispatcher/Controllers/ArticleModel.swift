import Foundation

struct ArticleModel: Decodable, Encodable {
    
    let id: Int
    let articleTitle: String
    //let date: Date
    //let url: String
    //let isFavorite: Bool
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case articleTitle = "title"
        case content = "body"
        //case isFavorite
        //case url
        //case date
    }
}

