import UIKit

class HomepageViewController: UIViewController, LoadingViewDelegate {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!
    
    private var currentPaginationPage = 1
    private var amountToFetch = 7
    private var totalPaginationPages = 1
    
    var newsArray: [Articles] = []
    var dataSource: TableViewDataSourceManager<Articles>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customHeader.initView(delegate: self, icon1: UIImage(named: "notifications"), icon2: UIImage(named: "search"), leftIcon: UIImage(named: "logo"))
        
        fetchInitialResults()
        
        self.dataSource = TableViewDataSourceManager(
                models: newsArray,
                reuseIdentifier: Constants.TableCellsIdentifier.homepage
            ) { article, cell in
                let currentCell = cell as! NewsCell
                currentCell.titleLabel.text = article.articleTitle
                currentCell.authorLabel.text = article.author
                currentCell.dateLabel.text = article.date
                currentCell.summaryLabel.text = article.content
                currentCell.subjectTag.setTitle(article.topic, for: .normal)
            }
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.register(UINib(nibName: Constants.NibNames.homepage, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.homepage)
        
        loadingView.initView(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func viewWillDisppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    func fetchInitialResults() {
        
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingView.loadIndicator.startAnimating()
        }
        
        self.fetchNewsFromAPI() {
            
            DispatchQueue.main.async {
                self.loadingView.loadIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
        }
    }
    
    
    func fetchNewsFromAPI(completionHandler: @escaping () -> ()){
        
        AlamofireManager(from: "\(Constants.apiCalls.newsUrl)?q=news&page_size=\(amountToFetch)&page=\(currentPaginationPage)").executeGetQuery(){
            (result: Result<ArticleModel,Error>) in
            switch result {
            case .success(let response):
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


// MARK: - CustomHeaderViewDelegate

extension HomepageViewController: CustomHeaderViewDelegate {
    
    func firstRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.homepageToNotifications, sender: self)
    }
    
    func secondRightIconPressed() {
        self.performSegue(withIdentifier: Constants.Segues.homepageToSearch, sender: self)
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
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            fetchNewsFromAPI() {
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
                }
            }
        }
    }
}
