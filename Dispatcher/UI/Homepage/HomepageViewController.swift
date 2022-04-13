import UIKit
import CoreData

class HomepageViewController: UIViewController, LoadingViewDelegate {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var sortbyView: SortbyView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = BaseArticlesViewModel()
    var dataSource: TableViewDataSourceManager<Article>!
    var isPaginating: Bool = false
    var selectedArticle: Article? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineNotificationCenterListeners()
        initiateUIElements()
        checkUserSettingsPreferences()
        viewModel.getSavedArticles() {
            self.fetchInitialNewsResults()
        }
    }
    
    
    func defineNotificationCenterListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableViewContent), name: NSNotification.Name(rawValue: Constants.NotificationCenter.FAVORITES_TO_HOMEPAGE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableViewContent), name: NSNotification.Name(rawValue: Constants.NotificationCenter.ARTICLE_TO_TABLES), object: nil)
    }
    
    
    @objc func refreshTableViewContent(_ notification: NSNotification) {

        if notification.userInfo![Constants.NotificationCenter.SENDER] as! String == Constants.NotificationCenter.SENDER_FAVORITES {
            viewModel.updateArticleToNotFavoriteLocally(articleID: notification.userInfo![Constants.NotificationCenter.ARTICLE_ID] as! String) {
                DispatchQueue.main.async {
                    self.dataSource.models = self.viewModel.newsArray
                    self.tableView.reloadData()
                }
            }
        } else {
            if notification.userInfo![Constants.NotificationCenter.IS_FAVORITE] as! String == "true" {
                viewModel.updateArticleToNotFavoriteLocally(articleID: notification.userInfo![Constants.NotificationCenter.ARTICLE_ID] as! String) {
                    DispatchQueue.main.async {
                        self.dataSource.models = self.viewModel.newsArray
                        self.tableView.reloadData()
                    }
                }
            } else {
                viewModel.updateArticleToYesFavoriteLocally(articleID: notification.userInfo![Constants.NotificationCenter.ARTICLE_ID] as! String) {
                    DispatchQueue.main.async {
                        self.dataSource.models = self.viewModel.newsArray
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func initiateUIElements() {
        customHeader.initView(delegate: self, apperanceType: .fullAppearance)
        sortbyView.initView(delegate: self)
        loadingView.initView(delegate: self)
        setupTableView()
    }
    
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.HOMEPAGE, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.HOMEPAGE)
        self.dataSource = TableViewDataSourceManager(
            models: viewModel.newsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.HOMEPAGE
        ) { article, cell in
            let currentCell = cell as! NewsCell
            currentCell.delegate = self
            
            currentCell.articleID = article.id
            if let imageUrl = article.imageUrl {
                currentCell.articleImageUrl = imageUrl
                guard let url = URL(string: imageUrl) else { return }
                UIImage.loadFrom(url: url) { image in
                    currentCell.newsImage.image = image
                }
            }
            currentCell.titleLabel.text = article.articleTitle
            currentCell.authorLabel.text = article.author
            currentCell.dateLabel.text = article.date
            currentCell.summaryLabel.text = article.content
            currentCell.subjectTag.setTitle(article.topic, for: .normal)
            currentCell.articleUrl = article.url
            if article.isFavorite {
                currentCell.isFavorite = true
                currentCell.favoriteIcon.image = UIImage(named: "favoriteArticle-selected")
            } else {
                currentCell.isFavorite = false
                currentCell.favoriteIcon.image = UIImage(named: "favoriteArticle-notSelected")
            }
        }
        tableView.dataSource = dataSource
        //tableView.delegate = self
    }
    
    
    func checkUserSettingsPreferences() {
        print("SAVE_FILTERS app setting is: \(viewModel.getUserAppSetting(of: Constants.UserDefaults.SAVE_FILTERS))")
        print("SEND_NOTIFICATIONS app setting is: \(viewModel.getUserAppSetting(of: Constants.UserDefaults.SEND_NOTIFICATIONS))")
    }
    
    
    @objc func fetchInitialNewsResults() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingView.loadIndicator.startAnimating()
        }
        viewModel.fetchNewsFromAPI(pageSizeToFetch: .articlesList) { error in
            if let error = error {
                print("Error fetching News: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dataSource.models = self.viewModel.newsArray
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.loadingView.loadIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


// MARK: - CustomHeaderViewDelegate
extension HomepageViewController: CustomHeaderViewDelegate {
    
    func notificationsButtonPressed() {
        self.performSegue(withIdentifier: Constants.Segues.HOMEPAGE_TO_NOTIFICATIONS, sender: self)
    }
    
    
    func searchButtonPressed() {
        self.performSegue(withIdentifier: Constants.Segues.HOMEPAGE_TO_SEARCH, sender: self)
    }
}

// MARK: - UIScrollViewDelegate
extension HomepageViewController: UIScrollViewDelegate {
    
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
            viewModel.fetchNewsFromAPI(pageSizeToFetch: .articlesList) { error in
                if let error = error {
                    print(error)
                } else {
                    self.dataSource.models = self.viewModel.newsArray
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.tableFooterView = nil
                    }
                }
                self.isPaginating = false
            }
        }
    }
}

// MARK: - NewsCellDelegate
extension HomepageViewController: NewsCellDelegate {
    
    func actionButtonDidPress(articleID: String) {
        let index = viewModel.newsArray.firstIndex(where: { $0.id == articleID })
        if let index = index {
            selectedArticle = viewModel.newsArray[index]
            self.performSegue(withIdentifier: Constants.Segues.HOMEPAGE_TO_ARTICLE, sender: self)
        }
    }
    
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        if let selectedArticle = selectedArticle {
            if segue.identifier == Constants.Segues.HOMEPAGE_TO_ARTICLE {
                let destinationVC = segue.destination as! ArticleViewController
                destinationVC.currentArticle = selectedArticle
            }
        }
    }
    
    
    func favoriteIconDidPress(forArticle article: Article) {
        if article.isFavorite {
            viewModel.removeArticleFromFavorites(articleID: article.id, completionHandler: handleFavoritesUpdate)
        } else {
            viewModel.addArticleToFavorites(article, completionHandler: handleFavoritesUpdate)
        }
    }
    
    
    func handleFavoritesUpdate(error: String?) {
        if let error = error {
            print(error)
        } else {
            DispatchQueue.main.async {
                self.dataSource.models = self.viewModel.newsArray
                self.tableView.reloadData()
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.HOMEPAGE_TO_FAVORITES), object: nil)
        }
    }
}

// MARK: - SortbyViewDelegate
extension HomepageViewController: SortbyViewDelegate {
    
    func filterIconDidPress() {
        print("Filter pane pressed")
    }
}
