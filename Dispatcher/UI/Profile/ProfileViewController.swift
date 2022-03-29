import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileShadowView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ProfileViewModel()
    var dataSource: TableViewDataSourceManager<ProfileOptionModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
    }
    
    func initiateUIElements() {
        addShadowsToHeader()
        setupTableView()
    }
    
    func addShadowsToHeader() {
        userProfileShadowView.layer.masksToBounds = false
        userProfileShadowView.layer.shadowColor = UIColor.black.cgColor
        userProfileShadowView.layer.shadowOpacity = 0.2
        userProfileShadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        userProfileShadowView.layer.shadowRadius = 3
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.PROFILE_OPTION, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.PROFILE_OPTION)
        self.dataSource = TableViewDataSourceManager(
            models: viewModel.optionsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.PROFILE_OPTION
        ) { option, cell in
            let currentcell = cell as! ProfileOptionCell
            currentcell.label.text = option.text
            currentcell.iconImageView.image = UIImage(named: option.icon)
        }
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.GO_TO_UPDATE_PROFILE, sender: self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


//MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if viewModel.optionsArray[indexPath.row].text.lowercased() != "logout" {
            if viewModel.optionsArray[indexPath.row].navigateTo != nil {
                self.performSegue(withIdentifier: viewModel.optionsArray[indexPath.row].navigateTo!, sender: self)
            }
        } else {
            viewModel.logUserOut() { error in
                if let error = error {
                    print(error)
                } else {
                    let login = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController")
                    self.present(login, animated: true, completion: nil)
                }
            }
        }
    }
}
