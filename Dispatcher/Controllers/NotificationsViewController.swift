import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var notificationsArray: [NotificationModel] = [
        NotificationModel(text: "Notification 1", wasRead: true),
        NotificationModel(text: "Notification 2", wasRead: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
        
        tableView.register(UINib(nibName: Constants.NibNames.notification, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.notification)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func viewWillDisppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
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
            return notificationsArray.count
        }
     
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellsIdentifier.notification, for: indexPath) as! NotificationCell

            return cell
        }
}

//MARK: - CustomHeaderViewDelegate
extension NotificationsViewController: CustomHeaderViewDelegate {

    func leftIconPressed() {
        navigationController?.popViewController(animated: true)
    }
}
