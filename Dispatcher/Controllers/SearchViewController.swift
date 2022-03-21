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
    
    
    
    var searchClearImageName: iconImageName = .search
    var recentSearchesArray: [String] = [
        "crypto",
        "soccer",
        "football"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        searchClearIcon.addGestureRecognizer(UITapGestureRecognizer(target: searchClearIcon, action: #selector(searchClearButtonPressed)))
        searchClearIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(searchClearButtonPressed(tapGestureRecognizer:)))
        searchClearIcon.addGestureRecognizer(tapGestureRecognizer1)
        
        goBackButton.addGestureRecognizer(UITapGestureRecognizer(target: goBackButton, action: #selector(goBackButtonPressed)))
        goBackButton.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(goBackButtonPressed(tapGestureRecognizer:)))
        goBackButton.addGestureRecognizer(tapGestureRecognizer2)
        
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.register(UINib(nibName: Constants.NibNames.recentSearch, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.recentSearch)
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
        recentSearchesView.isHidden = true
        recentSearchesTableView.isHidden = true
        
        let resultsView = SearchResultsView()
        resultsView.translatesAutoresizingMaskIntoConstraints = false
        let resultsViewWidthConstraint = resultsView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        let resultsViewHeightConstraint = resultsView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        NSLayoutConstraint.activate([resultsViewWidthConstraint,resultsViewHeightConstraint])
        view.addSubview(resultsView)
        
        let alignResultsViewToTop = resultsView.topAnchor.constraint(equalTo: searchView.bottomAnchor)
        let alignResultsViewToBottom = resultsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        let alignResultsViewHorizontally = resultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        NSLayoutConstraint.activate([alignResultsViewToTop,alignResultsViewToBottom,alignResultsViewHorizontally])
    }
}



// MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        recentSearchesView.isHidden = false
        recentSearchesTableView.isHidden = false
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
        }
    }
}


// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearchesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellsIdentifier.recentSearch, for: indexPath) as! RecentSearchCell
        cell.label.text = recentSearchesArray[indexPath.row]
        
        cell.cellIndex = indexPath.row
        cell.delegate = self
        
        return cell
    }
}


// MARK: - removeRecentSearchCellDelegate

extension SearchViewController: removeRecentSearchCellDelegate {
    
    func removeCellButtonDidPress(ofIndex index: Int) {
        print("Remove cell in index \(index)")
        recentSearchesArray.remove(at: index)
        recentSearchesTableView.reloadData()
    }
}
