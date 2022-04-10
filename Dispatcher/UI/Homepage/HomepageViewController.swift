import UIKit
import CoreData

class HomepageViewController: UIViewController, LoadingViewDelegate, UITableViewDelegate {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!

    let viewModel = BaseArticlesViewModel()
    var dataSource: TableViewDataSourceManager<Article>!
    var isPaginating: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        defineNotificationCenterListeners()
        initiateUIElements()
        checkUserSettingsPreferences()
        viewModel.getSavedArticles() {
            self.fetchInitialResults()
        }
    }
    
    func defineNotificationCenterListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableViewContent), name: NSNotification.Name(rawValue: Constants.NotificationCenter.favoritesToHomepage), object: nil)
    }
    
    @objc func refreshTableViewContent(_ notification: NSNotification) {
        print(notification.userInfo!["articleID"] as! String)
        print("notification reached homepage")
        viewModel.updateArticleToNotFavoriteLocally(articleID: notification.userInfo!["articleID"] as! String)
        DispatchQueue.main.async {
            self.dataSource.models = self.viewModel.newsArray
            self.tableView.reloadData()
        }
    }
    
    func initiateUIElements() {
        customHeader.initView(delegate: self, apperanceType: .fullAppearance)
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
        tableView.delegate = self
    }

    
    func checkUserSettingsPreferences() {
        print("SAVE_FILTERS app setting is: \(viewModel.getUserAppSetting(of: Constants.UserDefaults.SAVE_FILTERS))")
        print("SEND_NOTIFICATIONS app setting is: \(viewModel.getUserAppSetting(of: Constants.UserDefaults.SEND_NOTIFICATIONS))")
        print("SAVE_SEARCH_RESULTS app setting is: \(viewModel.getUserAppSetting(of: Constants.UserDefaults.SAVE_SEARCH_RESULTS))")
    }
    
    
    @objc func fetchInitialResults() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingView.loadIndicator.startAnimating()
        }
        viewModel.fetchNewsFromAPI(pageSizeToFetch: .articlesList) { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.dataSource.models = self.viewModel.newsArray
                    self.tableView.reloadData()
                }
            } else {
                print(error!)
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


// MARK: - NewsCellDelegate

extension HomepageViewController: NewsCellDelegate {
    
    func favoriteIconDidPress(forArticle article: Article) {
        if article.isFavorite {
            viewModel.removeArticleFromFavorites(articleID: article.id) { error in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.dataSource.models = self.viewModel.newsArray
                        self.tableView.reloadData()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.homepageToFavorites), object: nil)
                }
            }
        } else {
            viewModel.addArticleToFavorites(article) { error in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.dataSource.models = self.viewModel.newsArray
                        self.tableView.reloadData()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.homepageToFavorites), object: nil)
                }
            }
        }
    }
}


// MARK: - UIImage Extension to use URL

extension UIImage {

    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
