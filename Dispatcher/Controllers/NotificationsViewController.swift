import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: TableViewDataSourceManager<NotificationModel>!
    var notificationsArray: [NotificationModel] = [
        NotificationModel(text: "Notification 1", wasRead: true),
        NotificationModel(text: "Notification 2", wasRead: false)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.notification, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.notification)
        self.dataSource = TableViewDataSourceManager(
            models: notificationsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.notification
        ) { notification, cell in
            let currentCell = cell as! NotificationCell
            currentCell.label.text = notification.text
        }
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
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


//MARK: - CustomHeaderViewDelegate
extension NotificationsViewController: CustomHeaderViewDelegate {

    func leftIconPressed() {
        navigationController?.popViewController(animated: true)
    }
}
