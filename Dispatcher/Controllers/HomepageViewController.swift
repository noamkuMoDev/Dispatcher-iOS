import UIKit

class HomepageViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var newsArray: [Article] = [
        ArticleModel(title: "Title Article 1", date: Date(), url: "Content of the article", isFavorite: false, content: "http://noamkurtzer.co.il")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(for: Constants.ScreenNames.homepage)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - UITableViewDataSource
extension HomepageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let instance = newsArray[indexPath.row] as? ArticleModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) //as! specificCustomCell
            cell.textLabel?.text = instance.title
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
}

//MARK: - UITableViewDelegate
extension HomepageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
