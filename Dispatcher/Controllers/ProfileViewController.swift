import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileShadowView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var optionsArray: [ProfileOptionModel] = [
        ProfileOptionModel(icon: UIImage(named: "gearWheel")!, text: "Setting", navigateTo: Constants.Segues.goToSettings),
        ProfileOptionModel(icon: UIImage(named: "documents")!, text: "Terms & privacy", navigateTo: Constants.Segues.goToTermsAndPrivacy),
        ProfileOptionModel(icon: UIImage(named: "logout")!, text: "Logout")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileShadowView.layer.masksToBounds = false
        userProfileShadowView.layer.shadowColor = UIColor.black.cgColor
        userProfileShadowView.layer.shadowOpacity = 0.2
        userProfileShadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        userProfileShadowView.layer.shadowRadius = 3
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.NibNames.profileOption, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.profileOption)
    }
    
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.goToUpdateProfile, sender: self)
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        if segue.identifier == Constants.Segues.goToUpdateProfile {
            let destinationVC = segue.destination as! ViewProfileViewController
            //destinationVC.variableName = valueToSet // pass any variables?
        }
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

//MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellsIdentifier.profileOption, for: indexPath) as! ProfileOptionCell
        cell.label.text = optionsArray[indexPath.row].text
        cell.iconImageView.image = optionsArray[indexPath.row].icon
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            print("Settings")
            self.performSegue(withIdentifier: optionsArray[0].navigateTo!, sender: self)
            break
        case 1:
            print("Terms & privacy")
            self.performSegue(withIdentifier: optionsArray[1].navigateTo!, sender: self)
            break
        case 2:
            print("logout")
            //self.performSegue(withIdentifier: optionsArray[2].navigateTo!, sender: self)
            break
        default:
            print("non-existing option")
            break
        }
    }
}
