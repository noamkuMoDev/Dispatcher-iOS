import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, LoadingViewDelegate {
    
    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var newsArray: [Articles] = []
    
    private var currentPaginationPage = 1
    private var amountToFetch = 10
    private var totalPaginationPages = 1
    
    var dataSource: TableViewDataSourceManager<Articles>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customHeader.initView(delegate: self, icon1: UIImage(named: "notifications"), icon2: UIImage(named: "search"), leftIcon: UIImage(named: "logo"))
        loadingView.initView(delegate: self)
        
        displaySavedArticlesOnScreen()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.favorites, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.favorites)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func viewWillDisppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    func displaySavedArticlesOnScreen() {
        
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingView.loadIndicator.startAnimating()
        }
        
        self.fetchNewsFromAPI() {
            
            DispatchQueue.main.async {
                self.loadingView.loadIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
            
            if self.newsArray.count == 0 {
                //TO DO: tell user there are no saved articles
            }
        }
    }
    
    
    func fetchNewsFromAPI(completionHandler: @escaping () -> ()) {
        
        let alamofireQuery = AlamofireManager(from: "\(Constants.apiCalls.newsUrl)?q=news&page_size=\(amountToFetch)&page=\(currentPaginationPage)")

        if !alamofireQuery.isPaginating && currentPaginationPage <= totalPaginationPages {
            alamofireQuery.executeGetQuery() {
                ( result: Result<ArticleModel,Error> ) in
                switch result {
                case .success(let response):

                    self.currentPaginationPage += 1
                    self.totalPaginationPages = response.totalPages
                    
                    self.newsArray = response.articles
                    DispatchQueue.main.async {
                        self.dataSource.models = self.newsArray
                        self.tableView.reloadData()
                    }
                    completionHandler()
                    
                case .failure(let error):
                    print(error)
                    completionHandler()
                }
            }
        }
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
            
            fetchNewsFromAPI() {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                }
            }
        }
    }
}

