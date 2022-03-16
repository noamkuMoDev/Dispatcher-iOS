import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    //var dataSource = ArticleDataSource(cellIdentifier: Constants.TableCellsIdentifier.favorites)
    
    var newsArray: [ArticleModel] = [
        ArticleModel(id: 1, articleTitle: "Title Article 1", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il")
    ]
    
    var dataSource: TableViewDataSourceManager<ArticleModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customHeader.initView(delegate: self, icon1: UIImage(named: "notifications"), icon2: UIImage(named: "search"), leftIcon: UIImage(named: "logo"))
        
        self.dataSource = TableViewDataSourceManager(
                models: newsArray,
                reuseIdentifier: Constants.TableCellsIdentifier.favorites
            ) { savedArticle, cell in
                let currentCell = cell as! SavedArticleCell
                currentCell.articleTitle.text = savedArticle.articleTitle
            }
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.rowHeight = 115.0
        tableView.register(UINib(nibName: Constants.NibNames.favorites, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.favorites)
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

extension FavoritesViewController: CustomHeaderViewDelegate {
    
    func firstRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.favoritesToNotifications, sender: self)
    }
    
    func secondRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.favoritesToSearch, sender: self)
    }
}
