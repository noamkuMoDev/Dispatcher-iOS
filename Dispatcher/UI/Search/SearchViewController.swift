import UIKit

enum iconImageName {
    case search
    case remove
}

class SearchViewController: UIViewController, LoadingViewDelegate {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchClearIcon: UIImageView!
    @IBOutlet weak var goBackButton: UIImageView!
    
    @IBOutlet weak var recentSearchesView: UIView!
    @IBOutlet weak var recentSearchesTableView: UITableView!
    
    @IBOutlet weak var sortbyView: SortbyView!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    @IBOutlet weak var noResultsImageView: UIImageView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    @IBOutlet weak var loadingView: LoadingView!
    
    
    let viewModel = SearchViewModel()
    
    var searchClearImageName: iconImageName = .search
    
    var recentSearchesDataSource: TableViewDataSourceManager<RecentSearchModel>!
    var searchResultsDataSource: TableViewDataSourceManager<Article>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchSavedRecentSearchesFromUserDefaults()
        initiateUIElements()
        defineGestureRecognizers()
    }
    
    func initiateUIElements() {
        setupTextField()
        setupTableViews()
        initialHideShowElements()
    }
    
    func defineGestureRecognizers() {
        goBackButton.addGestureRecognizer(UITapGestureRecognizer(target: goBackButton, action: #selector(goBackButtonPressed)))
        goBackButton.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(goBackButtonPressed(tapGestureRecognizer:)))
        goBackButton.addGestureRecognizer(tapGestureRecognizer1)
        
        searchClearIcon.addGestureRecognizer(UITapGestureRecognizer(target: searchClearIcon, action: #selector(searchClearButtonPressed)))
        searchClearIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(searchClearButtonPressed(tapGestureRecognizer:)))
        searchClearIcon.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    func setupTextField() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func setupTableViews() {
        
        recentSearchesTableView.register(UINib(nibName: Constants.NibNames.RECENT_SEARCH, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.RECENT_SEARCH)
        self.recentSearchesDataSource = TableViewDataSourceManager(
            models: viewModel.recentSearchesArray,
            reuseIdentifier: Constants.TableCellsIdentifier.RECENT_SEARCH
        ) { search, cell in
            let currentcell = cell as! RecentSearchCell
            currentcell.label.text = search.text
            currentcell.delegate = self
        }
        recentSearchesTableView.dataSource = recentSearchesDataSource
        
        
        searchResultsTableView.register(UINib(nibName: Constants.NibNames.HOMEPAGE, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.HOMEPAGE)
        self.searchResultsDataSource = TableViewDataSourceManager(
            models: viewModel.searchResultsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.HOMEPAGE
        ) { article, cell in
            let currentcell = cell as! NewsCell
            currentcell.titleLabel.text = article.articleTitle
            currentcell.authorLabel.text = article.author
            currentcell.dateLabel.text = article.date
            currentcell.subjectTag.setTitle(article.topic, for: .normal)
            currentcell.summaryLabel.text = article.content
        }
        searchResultsTableView.dataSource = searchResultsDataSource
        searchResultsTableView.delegate = self
    }
    
    func initialHideShowElements() {
        loadingView.initView(delegate: self)
        loadingView.isHidden = true
        sortbyView.initView(delegate: self)
        sortbyView.isHidden = true
        searchResultsTableView.isHidden = true
        noResultsImageView.isHidden = true
        noResultsLabel.isHidden = true
    }
    
    @objc func goBackButtonPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearRecentSearchesPressed(_ sender: UIButton) {
        viewModel.clearRecentSearchesHistory() {
            DispatchQueue.main.async {
                self.recentSearchesTableView.reloadData()
            }
        }
    }
    
    
    func fetchInitialSearchResults(of keywords: String) {
        
        DispatchQueue.main.async {
            self.recentSearchesView.isHidden = true
            self.recentSearchesTableView.isHidden = true
            
            self.sortbyView.isHidden = false
            self.loadingView.isHidden = false
            self.loadingView.loadIndicator.startAnimating()
        }
        
        viewModel.searchResultsArray = []
        viewModel.fetchNewsFromAPI(searchWords: keywords) {
            DispatchQueue.main.async {
                self.searchResultsDataSource.models = self.viewModel.searchResultsArray
                self.searchResultsTableView.reloadData()
                self.loadingView.loadIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
            
            if self.viewModel.searchResultsArray.count == 0 {
                self.noResultsLabel.isHidden = false
                self.noResultsImageView.isHidden = false
                
            } else {
                self.searchResultsTableView.isHidden = false
                self.viewModel.saveNewRecentSearch(keywords) {
                    DispatchQueue.main.async {
                        self.searchResultsTableView.reloadData()
                    }
                }
            }
        }
    }
}



// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchResultsTableView.isHidden = true
            self.recentSearchesView.isHidden = false
            self.recentSearchesTableView.isHidden = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if searchClearImageName == .search {
            searchClearIcon.image = UIImage(named: "remove")
            searchClearImageName = .remove
        }
    }
    
    @objc func searchClearButtonPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        if searchClearImageName == .search {
            if searchTextField.text == "" {
                searchTextField.placeholder = "Enter search keywords"
            }
        } else {
            searchTextField.text = ""
            if searchClearImageName == .remove {
                searchClearIcon.image = UIImage(named: "search")
                searchClearImageName = .search
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text == "" {
            searchTextField.placeholder = "Enter search keywords"
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let searchText = searchTextField.text {
            fetchInitialSearchResults(of: searchText)
        }
    }
}


// MARK: - RecentSearchCellDelegate

extension SearchViewController: RecentSearchCellDelegate {
    
    func recentSearchPressed(called searchName: String) {
        
        searchTextField.text = searchName
        searchTextField.endEditing(true)
        if searchClearImageName == .search {
            searchClearIcon.image = UIImage(named: "remove")
            searchClearImageName = .remove
        }
        
        fetchInitialSearchResults(of: searchName)
        viewModel.updateRecentSearchesHistoryOrder(selectedSearch: searchName)
    }
    
    
    func removeCellButtonDidPress(called searchName: String) {
        
        viewModel.removeItemFromRecentSearchesHistory(searchToRemove: searchName) {
            self.recentSearchesDataSource.models = self.viewModel.recentSearchesArray
            DispatchQueue.main.async {
                self.recentSearchesTableView.reloadData()
            }
        }
    }
}


// MARK: - SortbyViewDelegate

extension SearchViewController: SortbyViewDelegate {
    
    func filterIconDidPress() {
        print("OPEN FILTERS PANE")
    }
}


// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == searchResultsTableView {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


// MARK: - UIScrollViewDelegate

extension SearchViewController: UIScrollViewDelegate {
    
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
        if position > (searchResultsTableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            viewModel.fetchNewsFromAPI(searchWords: searchTextField.text!) {
                DispatchQueue.main.async {
                    self.searchResultsDataSource.models = self.viewModel.searchResultsArray
                    self.searchResultsTableView.reloadData()
                    self.searchResultsTableView.tableFooterView = nil
                }
            }
        }
    }
}
