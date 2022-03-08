import UIKit

class ViewProfileViewController: HeaderViewController {

    @IBOutlet weak var myProfileTitleAndButton: UIView!
    @IBOutlet weak var changePictureLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func viewWillDisppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
    }
}
