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
        customHeader.initView(delegate: self, apperanceType: .backOnlyAppearance)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        customHeader.updateHeaderAppearanceType(to: .confirmCancelAppearance)
    }
}


//MARK: - CustomHeaderViewDelegate
extension ViewProfileViewController: CustomHeaderViewDelegate {
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func checkmarkButtonPressed() {
        //do something...
        customHeader.updateHeaderAppearanceType(to: .backOnlyAppearance)
    }
    
    func cancelButtonPressed() {
        //do something...
        customHeader.updateHeaderAppearanceType(to: .backOnlyAppearance)
    }
}
