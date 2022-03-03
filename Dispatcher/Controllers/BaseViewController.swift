import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var notificationsIcon: UIImageView!
    
    
    //Variables sent in
    var screenName: String = ""
    var tableContentArray: [Article] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - NavigationBar
    
    func setupNavigationBar(for screenName: String) {
        
        self.screenName = screenName
        
        DispatchQueue.main.async {
            switch screenName {
            case Constants.ScreenNames.profile:
                break
            case Constants.ScreenNames.homepage:
                self.setHeaderLeftLogo()
                self.setHeaderRightButtons()
                break
            case Constants.ScreenNames.favorites:
                self.setHeaderLeftLogo()
                self.setHeaderRightButtons()
                break
            default:
                self.setHeaderLeftLogo()
                break
            }
        }
    }
    
    
    private func setHeaderLeftLogo() {
        let logoImage = UIImage.init(named: "logo")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x:0.0,y:0.0, width:10,height:25.0)
        logoImageView.contentMode = .scaleAspectFill
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 60)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  imageItem
    }
    
    
    private func setHeaderRightButtons() {
        
        let avatar = UIButton(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
        avatar.setTitle("NK", for: .normal)
        avatar.backgroundColor = .gray
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "bell"),
                style: .done,
                target: self,
                action: #selector(goToNotifications)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .done,
                target: self,
                action: #selector(goToSearch)
            ),
            UIBarButtonItem(
                customView: avatar
            )
        ]
    }
    
    
    @objc func goToNotifications() {
        
        switch self.screenName {
        case Constants.ScreenNames.homepage:
            self.performSegue(withIdentifier: Constants.Segues.homepageToNotifications, sender: self)
            break
        case Constants.ScreenNames.favorites:
            self.performSegue(withIdentifier: Constants.Segues.favoritesToNotifications, sender: self)
            break
        default:
            break
        }
    }
    
    
    @objc func goToSearch() {
        
        switch self.screenName {
        case Constants.ScreenNames.homepage:
            self.performSegue(withIdentifier: Constants.Segues.homepageToSearch, sender: self)
            break
        case Constants.ScreenNames.favorites:
            self.performSegue(withIdentifier: Constants.Segues.favoritesToSearch
                              , sender: self)
            break
        default:
            break
        }
    }
}


////MARK: - UITableViewDataSource
//extension BaseViewController: UITableViewDataSource {
//
//    func populateTableContentArray(withItems contentArray: [Article]){
//        tableContentArray = contentArray
////        tableView.reloadData()
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableContentArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if let instance = tableContentArray[indexPath.row] as? ArticleModel {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) //as! specificCustomCell
//            cell.textLabel?.text = instance.title
//            return cell
//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath)
//            return cell
//        }
//    }
//}
//
////MARK: - UITableViewDelegate
//extension BaseViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
