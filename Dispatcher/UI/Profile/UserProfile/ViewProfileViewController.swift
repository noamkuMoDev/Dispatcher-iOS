import UIKit

class ViewProfileViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var changePictureLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUIElements()
    }
    
    func initializeUIElements() {
        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        customHeader.updateIcons(rightIcon: UIImage(named: "checkmark")!, leftIcon: UIImage(named: "close")!)
    }
}


//MARK: - CustomHeaderViewDelegate
extension ViewProfileViewController: CustomHeaderViewDelegate {
    
    func leftIconPressed() {
        navigationController?.popViewController(animated: true)
    }
}
