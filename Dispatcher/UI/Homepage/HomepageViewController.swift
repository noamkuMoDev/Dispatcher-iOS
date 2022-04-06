import UIKit
import CoreData

class HomepageViewController: UIViewController, LoadingViewDelegate, UITableViewDelegate {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!

    let appSettings = AppSettings.shared
    let viewModel = BaseArticlesViewModel()
    var dataSource: TableViewDataSourceManager<Article>!
    var isPaginating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
        checkUserSettingsPreferences()
        viewModel.fetchSavedArticles() {
            self.fetchInitialResults()
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
                }
            }
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    func checkUserSettingsPreferences() {
        print("SaveFilters is: \(appSettings.saveFilters)")
        print("SaveSearchResults is: \(appSettings.saveSearchResults)")
    }
    
    func fetchInitialResults() {
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
            print("clicked on a favorited article")
            viewModel.removeArticleFromFavorites(articleID: article.id) { error in
                if let error = error {
                    print(error)
                } else {
                    DispatchQueue.main.async {
                        self.dataSource.models = self.viewModel.newsArray
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            viewModel.addArticleToFavorites(article) {
                DispatchQueue.main.async {
                    print("need to refresh news table to show marked star")
                    self.dataSource.models = self.viewModel.newsArray
                    print(self.dataSource.models)
                    self.tableView.reloadData()
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
