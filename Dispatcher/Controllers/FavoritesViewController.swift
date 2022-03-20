import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var newsArray: [ArticleModel] = [
        ArticleModel(id: 1, articleTitle: "Title Article 1", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
        ArticleModel(id: 1, articleTitle: "Title Article 2", content: "http://noamkurtzer.co.il"),
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
        tableView.delegate = self
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

// MARK: - CustomHeaderViewDelegate

extension FavoritesViewController: CustomHeaderViewDelegate {
    
    func firstRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.favoritesToNotifications, sender: self)
    }
    
    func secondRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.favoritesToSearch, sender: self)
    }
}

// MARK: - UIScrollViewDelegate

extension FavoritesViewController: UIScrollViewDelegate {
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            let alamofireManager = AlamofireManager(from: "https://jsonplaceholder.typicode.com/posts")
            if !alamofireManager.isPaginating {
                
                tableView.tableFooterView = createSpinnerFooter()
                
                alamofireManager.executeGetQuery(){
                    (result: Result<[ArticleModel],Error>) in
                    DispatchQueue.main.async {
                        self.tableView.tableFooterView = nil
                    }
                    switch result{
                    case .success(let articles):
                        self.newsArray.append(contentsOf: articles)
                        DispatchQueue.main.async {
                            self.dataSource.models.append(contentsOf: articles)
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
