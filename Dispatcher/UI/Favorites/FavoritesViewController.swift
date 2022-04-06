import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, LoadingViewDelegate {
    
    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noResultsImageView: UIImageView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    let viewModel = BaseArticlesViewModel()
    var dataSource: TableViewDataSourceManager<FavoriteArticle>!
    var isPaginating: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineNotificationCenterListeners()
        initiateUIElements()
        displaySavedArticlesOnScreen()
    }
    
    func defineNotificationCenterListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableViewContent), name: NSNotification.Name(rawValue: Constants.NotificationCenter.homepageToFavorites), object: nil)
    }
    
    @objc func refreshTableViewContent() {
        self.dataSource.models = viewModel.savedArticlesSingleton.savedArticlesArray
        DispatchQueue.main.async {
            if self.viewModel.savedArticlesSingleton.savedArticlesArray.count == 0 {
                self.displayNoResults()
            } else {
                self.hideNoResults()
                self.tableView.reloadData()
            }
        }
    }
    
    func initiateUIElements() {
        customHeader.initView(delegate: self, apperanceType: .fullAppearance)
        loadingView.initView(delegate: self)
        hideNoResults()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.FAVORITES, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.FAVORITES)
        self.dataSource = TableViewDataSourceManager(
            models: viewModel.savedArticlesSingleton.savedArticlesArray,
            reuseIdentifier: Constants.TableCellsIdentifier.FAVORITES
        ) { savedArticle, cell in
            let currentCell = cell as! SavedArticleCell
            currentCell.delegate = self
            
            currentCell.articleID = savedArticle.id!
            
            if let imageUrl = savedArticle.imageUrl {
                guard let url = URL(string: imageUrl) else { return }
                UIImage.loadFrom(url: url) { image in
                    currentCell.articleImage.image = image
                }
            }
            currentCell.articleTitle.text = savedArticle.title
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
        
        viewModel.fetchSavedArticles() {
            DispatchQueue.main.async {
                self.loadingView.loadIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
            if self.viewModel.savedArticlesSingleton.savedArticlesArray.count == 0 {
                self.displayNoResults()
            } else {
                DispatchQueue.main.async {
                    self.dataSource.models = self.viewModel.savedArticlesSingleton.savedArticlesArray
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func displayNoResults() {
        self.tableView.isHidden = true
        self.noResultsLabel.isHidden = false
        self.noResultsImageView.isHidden = false
    }
    
    func hideNoResults() {
        self.tableView.isHidden = false
        self.noResultsLabel.isHidden = true
        self.noResultsImageView.isHidden = true
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

// MARK: - SavedArticleCellDelegate
extension FavoritesViewController: SavedArticleCellDelegate {
    
    func favoriteIconDidPress(forArticle articleID: String) {
        viewModel.removeArticleFromFavorites(articleID: articleID) { error in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    self.dataSource.models = self.viewModel.savedArticlesSingleton.savedArticlesArray
                    if self.viewModel.savedArticlesSingleton.savedArticlesArray.count == 0 {
                        self.displayNoResults()
                    } else {
                        self.tableView.reloadData()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.favoritesToHomepage), object: nil)
                }
            }
        }
    }
}
