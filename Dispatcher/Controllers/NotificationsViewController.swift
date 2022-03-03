import UIKit

class NotificationsViewController: UIViewController {

    var ourDataArray: [String] = [
    
    ]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: Constants.NibNames.notification, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.notification)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - UITableViewDelegate
extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource {
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ourDataArray.count
        }
     
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellsIdentifier.notification, for: indexPath) as! NotificationCell

            //cell.textLabel?.text = ourDataArray[indexPath.row]  // Array[number of the row].property
            return cell
        }

}
