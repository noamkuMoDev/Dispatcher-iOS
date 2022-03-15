import UIKit

class HomepageViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
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
                reuseIdentifier: Constants.TableCellsIdentifier.homepage,
                cellType: .article
            ) { article, cell in
                    //cell.cellTextLabel?.text = article.articleTitle
            }
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.register(UINib(nibName: Constants.NibNames.homepage, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.homepage)
        
        AlamofireManager(from: "https://jsonplaceholder.typicode.com/posts").executeGetQuery(){
            (result: Result<[ArticleModel],Error>) in
            switch result{
            case .success(let articles):
                self.newsArray = articles
                
                DispatchQueue.main.async {
                    self.dataSource.models = self.newsArray
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
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
    
    func firstRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.homepageToNotifications, sender: self)
    }
    
    func secondRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.homepageToSearch, sender: self)
    }
}
