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
    
    
    let defaults = UserDefaults.standard
    
    private var currentPaginationPage = 1
    private var amountToFetch = 7
    private var totalPaginationPages = 1
    
    var searchClearImageName: iconImageName = .search
    
    var recentSearchesDataSource: TableViewDataSourceManager<RecentSearchModel>!
    var recentSearchesArray: [RecentSearchModel] = []
    var searchResultsDataSource: TableViewDataSourceManager<Articles>!
    var searchResultsArray: [Articles] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextField()
        setupTableViews()
        defineGestureRecognizers()
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
        if let savedRecentSearches = defaults.array(forKey: Constants.UserDefaults.recentSearches) as? [String] {
            for search in savedRecentSearches {
                recentSearchesArray.append(RecentSearchModel(text: search))
            }
        }
        recentSearchesTableView.register(UINib(nibName: Constants.NibNames.recentSearch, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.recentSearch)
        self.recentSearchesDataSource = TableViewDataSourceManager(
            models: recentSearchesArray,
            reuseIdentifier: Constants.TableCellsIdentifier.recentSearch
        ) { search, cell in
            let currentcell = cell as! RecentSearchCell
            currentcell.label.text = search.text
            currentcell.delegate = self
        }
        recentSearchesTableView.dataSource = recentSearchesDataSource
        
        
        searchResultsTableView.register(UINib(nibName: Constants.NibNames.homepage, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.homepage)
        self.searchResultsDataSource = TableViewDataSourceManager(
            models: searchResultsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.homepage
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
        recentSearchesArray = []
        updateModelArrayIntoUserDefaults()
        DispatchQueue.main.async {
            self.recentSearchesTableView.reloadData()
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
        
        self.fetchNewsFromAPI(query: keywords) {
            
            DispatchQueue.main.async {
                self.loadingView.loadIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }

            if self.searchResultsArray.count == 0 {
                self.noResultsLabel.isHidden = false
                self.noResultsImageView.isHidden = false
                
            } else {
                self.searchResultsTableView.isHidden = false
                self.saveNewRecentSearch(keywords)
            }
        }
    }
    
    
    func fetchNewsFromAPI(query:String = "news", completionHandler: @escaping () -> ()) {
        print("LOOKING FOR NEWS ABOUT: \(query)")
        let alamofireQuery = AlamofireManager(from: "\(Constants.apiCalls.newsUrl)?q=\(query)&page_size=\(amountToFetch)&page=\(currentPaginationPage)")

        if !alamofireQuery.isPaginating && currentPaginationPage <= totalPaginationPages {
            alamofireQuery.executeGetQuery() {
                ( result: Result<ArticleModel,Error> ) in
                switch result {
                case .success(let response):

                    self.currentPaginationPage += 1
                    if let safeTotalPages = response.totalPages {
                        self.totalPaginationPages = safeTotalPages
                    }
                    
                    self.searchResultsArray = response.articles
                    DispatchQueue.main.async {
                        self.searchResultsDataSource.models = self.searchResultsArray
                        self.searchResultsTableView.reloadData()
                    }
                    completionHandler()
                    
                case .failure(let error):
                    print(error)
                    completionHandler()
                }
            }
        }
    }
    
    
    func saveNewRecentSearch(_ keyword: String){
        
        if !recentSearchesArray.contains(where: {$0.text == keyword}) {
            recentSearchesArray.insert(RecentSearchModel(text: keyword), at: 0)
            
            if recentSearchesArray.count > 10 {
                recentSearchesArray.remove(at: recentSearchesArray.count-1)
            }
            
            updateModelArrayIntoUserDefaults()
        }
    }
    
    
    func updateModelArrayIntoUserDefaults() {
        var stringsRecentSearches: [String] = []
        for search in recentSearchesArray {
            stringsRecentSearches.append(search.text)
        }
        defaults.set(stringsRecentSearches, forKey: Constants.UserDefaults.recentSearches)
    }
}



// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
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
        if searchClearImageName == .search {
            searchClearIcon.image = UIImage(named: "remove")
            searchClearImageName = .remove
        }
        
        fetchInitialSearchResults(of: searchName)
        
        let index = recentSearchesArray.firstIndex(where: { $0.text == searchName })!
        recentSearchesArray.insert(recentSearchesArray[index], at: 0)
        recentSearchesArray.remove(at: index+1)
        updateModelArrayIntoUserDefaults()
    }
    
    
    func removeCellButtonDidPress(called searchName: String) {
        recentSearchesArray = recentSearchesArray.filter { $0.text !=  searchName}
        self.recentSearchesDataSource.models = self.recentSearchesArray
        DispatchQueue.main.async {
            self.recentSearchesTableView.reloadData()
        }
        updateModelArrayIntoUserDefaults()
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
            
            fetchNewsFromAPI(query: searchTextField.text!) {
                DispatchQueue.main.async {
                    self.searchResultsTableView.tableFooterView = nil
                }
            }
        }
    }
}
