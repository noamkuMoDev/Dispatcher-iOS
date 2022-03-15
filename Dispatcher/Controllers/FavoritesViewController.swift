import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    //var dataSource = ArticleDataSource(cellIdentifier: Constants.TableCellsIdentifier.favorites)
    
    var newsArray: [ArticleModel] = [
        ArticleModel(id: 1, articleTitle: "Title Article 1", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il")
    ]
    
    var dataSource: TableViewManager<ArticleModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customHeader.initView(delegate: self, icon1: UIImage(named: "notifications"), icon2: UIImage(named: "search"), leftIcon: UIImage(named: "logo"))
        
        self.dataSource = TableViewManager(
                models: newsArray,
                reuseIdentifier: Constants.TableCellsIdentifier.favorites,
                cellType: .savedArticle
            ) { savedArticle, cell in
                //cell.textLabel?.text = savedArticle.articleTitle
                //cell.detailTextLabel?.text = savedArticle.content
            }
        
        tableView.rowHeight = 115.0
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: Constants.NibNames.favorites, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.favorites)
        
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        //dataSource.newsArray = newsArray
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
