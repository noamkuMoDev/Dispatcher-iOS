import UIKit

class HomepageViewController: UIViewController, LoadingViewDelegate, UITableViewDelegate {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var tableView: UITableView!

    let viewModel = HomepageViewModel()
    var dataSource: TableViewDataSourceManager<Article>!
    var isPaginating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
        fetchInitialResults()
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
        viewModel.fetchNewsFromAPI() { error in
            print(error ?? "")
            DispatchQueue.main.async {
                self.dataSource.models = self.viewModel.newsArray
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
            viewModel.fetchNewsFromAPI() { error in
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
