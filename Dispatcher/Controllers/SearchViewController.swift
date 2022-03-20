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
    
    var searchClearImageName: iconImageName = .search
    
    var recentSearchesDataSource: TableViewDataSourceManager<RecentSearchModel>!
    var recentSearchesArray: [RecentSearchModel] = []
    
    var searchResultsDataSource: TableViewDataSourceManager<ArticleModel>!
    var searchResultsArray: [ArticleModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goBackButton.addGestureRecognizer(UITapGestureRecognizer(target: goBackButton, action: #selector(goBackButtonPressed)))
        goBackButton.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(goBackButtonPressed(tapGestureRecognizer:)))
        goBackButton.addGestureRecognizer(tapGestureRecognizer1)
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        searchClearIcon.addGestureRecognizer(UITapGestureRecognizer(target: searchClearIcon, action: #selector(searchClearButtonPressed)))
        searchClearIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(searchClearButtonPressed(tapGestureRecognizer:)))
        searchClearIcon.addGestureRecognizer(tapGestureRecognizer2)
        
        
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
        }
        searchResultsTableView.dataSource = searchResultsDataSource

        
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
    
    
    func fetchSearchResults(of keywords: String){

        recentSearchesView.isHidden = true
        recentSearchesTableView.isHidden = true
        
        sortbyView.isHidden = false
        loadingView.isHidden = false
        loadingView.loadIndicator.startAnimating()
        
        
        AlamofireManager(from: "https://jsonplaceholder.typicode.com/posts").executeGetQuery(){
            (result: Result<[ArticleModel],Error>) in
            
            switch result {
            case .success (let articles):
                self.searchResultsArray = articles
                DispatchQueue.main.async {
                    self.searchResultsDataSource.models = self.searchResultsArray
                    self.searchResultsTableView.reloadData()
                }
            case .failure (let error):
                print(error)
            }
            
            if self.searchResultsArray.count == 0 {
                self.noResultsLabel.isHidden = false
                self.noResultsImageView.isHidden = false
            } else {
                self.searchResultsTableView.isHidden = false
                
                self.saveNewRecentSearch(keywords)
            }
            self.loadingView.loadIndicator.stopAnimating()
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
        //print("text changed to to: \(searchTextField.text ?? "") ")
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
        //print("keyboard return btn pressed - Dismiss keyaboard")
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
            fetchSearchResults(of: searchText)
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
        
        fetchSearchResults(of: searchName)
        
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
            print(indexPath.row)     // index of the row that was tapped
            tableView.deselectRow(at: indexPath, animated: true) //make the row not stay colored
        }
    }
}
