import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, LoadingViewDelegate {
    
    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noResultsImageView: UIImageView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    
    let viewModel = BaseArticlesViewModel()
    var dataSource: TableViewDataSourceManager<Article>!
    var isPaginating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
        displaySavedArticlesOnScreen()
    }
    
    func initiateUIElements() {
        customHeader.initView(delegate: self, apperanceType: .fullAppearance)
        loadingView.initView(delegate: self)
        noResultsLabel.isHidden = true
        noResultsImageView.isHidden = true
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.FAVORITES, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.FAVORITES)
        self.dataSource = TableViewDataSourceManager(
            models: viewModel.newsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.FAVORITES
        ) { savedArticle, cell in
            let currentCell = cell as! SavedArticleCell
            currentCell.articleTitle.text = savedArticle.articleTitle
            currentCell.articleTopic.setTitle(savedArticle.topic, for: .normal)
        }
        tableView.delegate = self
        tableView.dataSource = self.dataSource
        tableView.rowHeight = 115.0
    }
    
    func displaySavedArticlesOnScreen() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingView.loadIndicator.startAnimating()
        }
        viewModel.fetchNewsFromAPI(pageSizeToFetch: .savedArticles) { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.dataSource.models = self.viewModel.newsArray
                    self.tableView.reloadData()
                    self.loadingView.loadIndicator.stopAnimating()
                    self.loadingView.isHidden = true
                }
            } else {
                print(error!)
            }
            
            if self.viewModel.newsArray.count == 0 {
                self.tableView.isHidden = true
                self.noResultsLabel.isHidden = false
                self.noResultsImageView.isHidden = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


// MARK: - CustomHeaderViewDelegate
extension FavoritesViewController: CustomHeaderViewDelegate {
    
    func notificationsButtonPressed() {
        self.performSegue(withIdentifier: Constants.Segues.FAVORITES_TO_NOTIFICATIONS, sender: self)
    }
    
    func searchButtonPressed() {
        self.performSegue(withIdentifier: Constants.Segues.FAVORITES_TO_SEARCH, sender: self)
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
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) && !isPaginating {
            isPaginating = true
            viewModel.fetchNewsFromAPI(pageSizeToFetch: .savedArticles) { error in
                if error == nil {
                    self.dataSource.models = self.viewModel.newsArray
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.tableFooterView = nil
                    }
                } else {
                    print(error!)
                }
                self.isPaginating = false
            }
        }
    }
}

