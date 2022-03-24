import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = NotificationsViewModel()
    var dataSource: TableViewDataSourceManager<NotificationModel>!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initiateUIElements()
    }
    
    func initiateUIElements() {
        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.NOTIFICATION, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.NOTIFICATION)
        self.dataSource = TableViewDataSourceManager(
            models: viewModel.notificationsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.NOTIFICATION
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
}


//MARK: - CustomHeaderViewDelegate
extension NotificationsViewController: CustomHeaderViewDelegate {

    func leftIconPressed() {
        navigationController?.popViewController(animated: true)
    }
}
