import UIKit

class HomepageViewController: BaseViewController {
    
    var dataSource = ArticleDataSource()

    
    @IBOutlet weak var tableView: ContentTableView!
    
    
    var newsArray: [Article] = [
        ArticleModel(title: "Title Article 1", date: Date(), url: "Content of the article", isFavorite: false, content: "http://noamkurtzer.co.il")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(for: Constants.ScreenNames.homepage)

        tableView.register(UINib(nibName: Constants.NibNames.homepage, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.homepage)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        dataSource.newsArray = newsArray
        dataSource.cellIdentifier = Constants.TableCellsIdentifier.homepage
    }
}
