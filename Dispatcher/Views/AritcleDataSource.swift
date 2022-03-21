import UIKit

class ArticleDataSource: NSObject {
    
    var newsArray: [Article] = []
    var cellIdentifier: String = ""
}

//MARK: - UITableViewDataSource

extension ArticleDataSource: UITableViewDataSource {
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return newsArray.count
        }
     
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            //Define the custom cell                                    identifier                       classsName
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) //as! cellType

            //cell.textLabel?.text = newsArray[indexPath.row].title
            return cell
        }
}


//MARK: - UITableViewDelegate

extension ArticleDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
