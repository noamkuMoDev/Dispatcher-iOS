import UIKit

class HomepageViewController: UIViewController {

    var customHeader: CustomHeaderView?
    var dataSource = ArticleDataSource()

    @IBOutlet weak var tableView: UITableView!
    
    
    var newsArray: [Article] = [
        ArticleModel(title: "Title Article 1", date: Date(), url: "Content of the article", isFavorite: false, content: "http://noamkurtzer.co.il"),
        ArticleModel(title: "Title Article 2", date: Date(), url: "Content of 2nd article", isFavorite: false, content: "http://noamkurtzer.co.il")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customHeader?.delegate = self
        
        tableView.register(UINib(nibName: Constants.NibNames.homepage, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.homepage)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        dataSource.newsArray = newsArray
        dataSource.cellIdentifier = Constants.TableCellsIdentifier.homepage
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

extension HomepageViewController: CustomHeaderViewDelegate {
    
    func btnWasPressed() {
        print("button was pressed!")
    }
}
