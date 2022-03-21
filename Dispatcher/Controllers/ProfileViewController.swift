import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileShadowView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var dataSource: TableViewDataSourceManager<ProfileOptionModel>!
    
    var optionsArray: [ProfileOptionModel] = [
        ProfileOptionModel(icon: "gearWheel", text: "Setting", navigateTo: Constants.Segues.goToSettings),
        ProfileOptionModel(icon: "documents", text: "Terms & privacy", navigateTo: Constants.Segues.goToTermsAndPrivacy),
        ProfileOptionModel(icon: "logout", text: "Logout")
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        tableView.register(UINib(nibName: Constants.NibNames.profileOption, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.profileOption)
        self.dataSource = TableViewDataSourceManager(
            models: optionsArray,
            reuseIdentifier: Constants.TableCellsIdentifier.profileOption
        ) { option, cell in
            print(option)
            let currentcell = cell as! ProfileOptionCell
            currentcell.label.text = option.text
            currentcell.iconImageView.image = UIImage(named: option.icon)
        }
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.goToUpdateProfile, sender: self)
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

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if optionsArray[indexPath.row].text != "logout" {
            if optionsArray[indexPath.row].navigateTo != nil {
                self.performSegue(withIdentifier: optionsArray[indexPath.row].navigateTo!, sender: self)
            }
        } else {
            // TO DO : log the user out, then navigate to login screen
        }
    }
}
