import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: TableViewManager<NotificationModel>!
    var notificationsArray: [NotificationModel] = [
        NotificationModel(text: "Notification 1", wasRead: true),
        NotificationModel(text: "Notification 2", wasRead: false)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
        
        tableView.register(UINib(nibName: Constants.NibNames.notification, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.notification)
        self.dataSource = TableViewManager(
            models: notificationsArray,  // pass data array
            reuseIdentifier: Constants.TableCellsIdentifier.notification, // pass custom cell identifier
            cellType: .notification // pass type of custom cell
        ) { notification, cell in
            //cell.label!.text = notification.text
            print("===========================================================================")
            print("===========================================================================")
            print(notification)
            print(cell)
            print("===========================================================================")
            print("===========================================================================")
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
