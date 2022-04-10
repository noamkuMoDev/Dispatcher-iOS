import UIKit

class SplashViewController: UIViewController {

    let viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("SPLASHSCREEN calling checkIfLoggedIn")
        if viewModel.checkIfLoggedIn() == .loggedIn {
            DispatchQueue.main.async {
                let homepage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTabBarController")
                self.present(homepage, animated: true, completion: nil)
            }
        } else {
            print("USER NOT LOGGED IN so display auth screen")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.Segues.SPLASH_TO_AUTH, sender: self)
            }
        }
    }
}
