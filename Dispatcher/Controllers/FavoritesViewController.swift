import UIKit

class FavoritesViewController: UIViewController {
    
    var dataSource = ArticleDataSource()
    
    @IBOutlet weak var header: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var newsArray: [Article] = [
        ArticleModel(title: "Title Article 1", date: Date(), url: "Content of the article", isFavorite: true, content: "http://noamkurtzer.co.il"),
        ArticleModel(title: "Title Article 2", date: Date(), url: "Content of 2nd article", isFavorite: true, content: "http://noamkurtzer.co.il")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 115.0
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: Constants.NibNames.favorites, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.favorites)
        
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        dataSource.newsArray = newsArray
        dataSource.cellIdentifier = Constants.TableCellsIdentifier.favorites
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func viewWillDisppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
