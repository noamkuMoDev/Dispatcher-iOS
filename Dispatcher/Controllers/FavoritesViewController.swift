import UIKit

class FavoritesViewController: BaseViewController {
    
    var dataSource = ArticleDataSource()
    
    @IBOutlet weak var tableView: UITableView!
    
    var newsArray: [Article] = [
        ArticleModel(title: "Title Article 1", date: Date(), url: "Content of the article", isFavorite: false, content: "http://noamkurtzer.co.il")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(for: Constants.ScreenNames.favorites)
        
        tableView.register(UINib(nibName: Constants.NibNames.favorites, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.favorites)
        
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        dataSource.newsArray = newsArray
        dataSource.cellIdentifier = Constants.TableCellsIdentifier.favorites
    }
}
