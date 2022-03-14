import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = ArticleDataSource()
    
    var newsArray: [Article] = [
        ArticleModel(title: "Title Article 1", date: Date(), url: "Content of the article", isFavorite: true, content: "http://noamkurtzer.co.il"),
        ArticleModel(title: "Title Article 2", date: Date(), url: "Content of 2nd article", isFavorite: true, content: "http://noamkurtzer.co.il")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customHeader.initView(delegate: self, icon1: UIImage(named: "notifications"), icon2: UIImage(named: "search"), leftIcon: UIImage(named: "logo"))
        
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

extension FavoritesViewController: CustomHeaderViewDelegate {
    
    func firstRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.favoritesToNotifications, sender: self)
    }
    
    func secondRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.favoritesToSearch, sender: self)
    }
}
