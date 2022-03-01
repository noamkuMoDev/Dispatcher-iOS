import UIKit

class BaseViewController: UIViewController {

    var screenName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
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
