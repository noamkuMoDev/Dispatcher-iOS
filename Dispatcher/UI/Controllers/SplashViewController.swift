import UIKit

class SplashViewController: UIViewController {

    let repository = AuthRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if repository.checkIfLoggedIn() == .loggedIn {
            DispatchQueue.main.async {
                let homepage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTabBarController")
                self.present(homepage, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.Segues.SPLASH_TO_AUTH, sender: self)
            }
        }
    }
}
