import UIKit

enum iconImageName {
    case search
    case remove
}

class SearchViewController: UIViewController {
    
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
    
    
    var searchClearImageName: iconImageName = .search
    
    var recentSearchesDataSource: TableViewDataSourceManager<RecentSearchModel>!
    var recentSearchesArray: [RecentSearchModel] = [
        RecentSearchModel(text: "crypto"),
        RecentSearchModel(text: "soccer"),
    ]
    
    var searchResultsDataSource: TableViewDataSourceManager<ArticleModel>!
    var searchResultsArray: [ArticleModel] = [
        ArticleModel(id: 4, articleTitle: "Some title", content: "Some content")
    ]
    
    
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

        
        
        //Hide / Show Elements
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
        print("Clear the table view and history in database")
        recentSearchesArray = []
        recentSearchesTableView.reloadData()
    }
    
    
    func displaySearchResults(){
        print("displaySearchResults")
        recentSearchesView.isHidden = true
        recentSearchesTableView.isHidden = true
        
        sortbyView.isHidden = false
        if searchResultsArray.count == 0 {
            noResultsLabel.isHidden = false
            noResultsImageView.isHidden = false
        } else {
            searchResultsTableView.isHidden = false
        }
    }
}



// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("changed text to: \(searchTextField.text ?? "") so fetch data")
        if searchClearImageName == .search {
            searchClearIcon.image = UIImage(named: "remove")
            searchClearImageName = .remove
        }
    }
    
    @objc func searchClearButtonPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        
        if searchClearImageName == .search {
            if searchTextField.text == "" {
                searchTextField.placeholder = "Enter search keywords"
            } else {
                print("magnifying glass was pressed. textFieldShouldEndEditing now runs")
                searchTextField.endEditing(true)
                
                displaySearchResults()
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
        print("return btn pressed in keyboard. Dismiss keyaboard")
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
            print("Let's FETCH DATA of the search words: \(searchText)")
            displaySearchResults()
        }
    }
}


// MARK: - removeRecentSearchCellDelegate

extension SearchViewController: removeRecentSearchCellDelegate {
    
    func removeCellButtonDidPress(called searchName: String) {
        recentSearchesArray = recentSearchesArray.filter { $0.text !=  searchName}
        self.recentSearchesDataSource.models = self.recentSearchesArray
        recentSearchesTableView.reloadData()
    }
}


// MARK: - SortbyViewDelegate

extension SearchViewController: SortbyViewDelegate {
    
    func filterIconDidPress() {
        print("OPEN FILTERS PANE")
    }
}


