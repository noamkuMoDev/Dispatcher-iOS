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
    var selectedArticle: Article? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defineNotificationCenterListeners()
        initiateUIElements()
        displaySavedArticlesOnScreen()
    }
    

    func defineNotificationCenterListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableViewContent), name: NSNotification.Name(rawValue: Constants.NotificationCenter.HOMEPAGE_TO_FAVORITES), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableViewContent), name: NSNotification.Name(rawValue: Constants.NotificationCenter.ARTICLE_TO_TABLES), object: nil)
    }
    

    @objc func refreshTableViewContent(_ notification: NSNotification) {
        viewModel.getSavedArticles {
            self.dataSource.models = self.viewModel.savedArticles.map({$0.value}).sorted(by: {$0.timestamp! > $1.timestamp!})
            DispatchQueue.main.async {
                if self.viewModel.savedArticles.count == 0 {
                    self.displayNoResults()
                } else {
                    self.hideNoResults()
                    self.tableView.reloadData()
                }
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
            models: viewModel.savedArticles.map({$0.value}).sorted(by: {$0.timestamp! > $1.timestamp!}),
            reuseIdentifier: Constants.TableCellsIdentifier.FAVORITES
        ) { savedArticle, cell in
            let currentCell = cell as! SavedArticleCell
            currentCell.delegate = self
            
            currentCell.articleID = savedArticle.id!
            currentCell.articleTitle.text = savedArticle.title
            currentCell.articleTopic.setTitle(savedArticle.topic, for: .normal)
            if let imageUrl = savedArticle.imageUrl {
                guard let url = URL(string: imageUrl) else { return }
                UIImage.loadFrom(url: url) { image in
                    currentCell.articleImage.image = image
                }
            }
        }
        tableView.dataSource = self.dataSource
        tableView.rowHeight = 115.0
    }
    

    func displaySavedArticlesOnScreen() {
        displayLoadingAnimation()
        viewModel.getSavedArticles() {
            if self.viewModel.savedArticles.count == 0 {
                self.displayNoResults()
            } else {
                DispatchQueue.main.async {
                    self.dataSource.models = self.viewModel.savedArticles.map({$0.value}).sorted(by: {$0.timestamp! > $1.timestamp!})
                    self.tableView.reloadData()
                }
            }
            self.removeLoadingAnimation()
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
    

    func displayLoadingAnimation() {
        DispatchQueue.main.async {
            self.loadingView.loadIndicator.startAnimating()
            self.loadingView.isHidden = false
        }
    }
    

    func removeLoadingAnimation() {
        DispatchQueue.main.async {
            self.loadingView.loadIndicator.stopAnimating()
            self.loadingView.isHidden = true
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        setStatusBarColor(viewController: self)
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
    
    func cellDidPress(articleID: String) {
        let favorite = viewModel.savedArticles[articleID]
        if let favorite = favorite {
            selectedArticle = Article(id: favorite.id!, articleTitle: favorite.title!, date: favorite.date!, url: favorite.url!, content: favorite.content!, author: favorite.author!, topic: favorite.topic!, imageUrl: favorite.imageUrl!, isFavorite: true)
            self.performSegue(withIdentifier: Constants.Segues.FAVORITES_TO_ARTICLE, sender: self)
        }
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        if let selectedArticle = selectedArticle {
            if segue.identifier == Constants.Segues.FAVORITES_TO_ARTICLE {
                let destinationVC = segue.destination as! ArticleViewController
                destinationVC.currentArticle = selectedArticle
            }
        }
    }
    
    
    func favoriteIconDidPress(forArticle articleID: String) {
        displayLoadingAnimation()
        viewModel.removeArticleFromFavorites(articleID: articleID) { error in
            if let error = error {
                print(error)
                self.removeLoadingAnimation()
            } else {
                DispatchQueue.main.async {
                    self.dataSource.models = self.viewModel.savedArticles.map({$0.value}).sorted(by: {$0.timestamp! > $1.timestamp!})
                    if self.viewModel.savedArticles.count == 0 {
                        self.displayNoResults()
                    } else {
                        self.tableView.reloadData()
                    }
                    let dataDict:[String: String] = [
                        Constants.NotificationCenter.ARTICLE_ID: articleID,
                        Constants.NotificationCenter.SENDER: Constants.NotificationCenter.SENDER_FAVORITES
                    ]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.FAVORITES_TO_HOMEPAGE), object: nil, userInfo: dataDict)
                    self.removeLoadingAnimation()
                }
            }
        }
    }
}
