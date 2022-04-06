import Foundation

class ArticlesArray {
    
    private init() {}
    static var shared = ArticlesArray()
    var newsArray: [Article] = []
    
}
