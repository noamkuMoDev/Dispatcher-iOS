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
        customHeader.initView(delegate: self, apperanceType: .backOnlyAppearance)
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.NOTIFICATION, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.NOTIFICATION)
        self.dataSource = TableViewDataSourceManager(
            models: viewModel.notificationsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.NOTIFICATION
        ) { notification, cell in
            let currentCell = cell as! NotificationCell
            currentCell.delegate = self
            currentCell.label.text = notification.text
            if !notification.wasRead {
                currentCell.label.textColor = UIColor.lightGray
                currentCell.entireCell.backgroundColor = hexStringToUIColor(hex: "#FAFAFA")
                currentCell.verticalLine.image = UIImage(named: "NotificationVerticleLine-Gray")
            }
        }
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        setStatusBarColor(viewController: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: false)
    }
}


//MARK: - CustomHeaderViewDelegate
extension NotificationsViewController: CustomHeaderViewDelegate {

    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableViewDelegate
extension NotificationsViewController: UITableViewDelegate {
    
    // TO DO: add pagination & loading footer to table
}


//MARK: - NotificationCellDelegate
extension NotificationsViewController: NotificationCellDelegate {
    
    func notificationDidPress(notificationText: String) {
        print("pressed notification with content: \(notificationText)")
    }
}
