import UIKit

class HomepageViewController: UIViewController, LoadingViewDelegate, UITableViewDelegate {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!

    var homepageVM = HomepageViewModel()
    var dataSource: TableViewDataSourceManager<Articles>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
        fetchInitialResults()
    }
    
    func initiateUIElements() {
        customHeader.initView(delegate: self, icon1: UIImage(named: "notifications"), icon2: UIImage(named: "search"), leftIcon: UIImage(named: "logo"))
        loadingView.initView(delegate: self)
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.homepage, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.homepage)
        self.dataSource = TableViewDataSourceManager(
                models: homepageVM.newsArray,
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
        tableView.delegate = self
    }

    func fetchInitialResults() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingView.loadIndicator.startAnimating()
        }
        homepageVM.fetchNewsFromAPI() {
            
            DispatchQueue.main.async {
                self.dataSource.models = self.homepageVM.newsArray
                self.tableView.reloadData()
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
            homepageVM.fetchNewsFromAPI() {
                self.dataSource.models = self.homepageVM.newsArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.tableFooterView = nil
                }
            }
        }
    }
}
