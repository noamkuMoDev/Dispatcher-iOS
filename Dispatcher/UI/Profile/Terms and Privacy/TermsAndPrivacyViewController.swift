import UIKit

class TermsAndPrivacyViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
    }
    

    func initiateUIElements() {
        customHeader.initView(delegate: self, apperanceType: .backOnlyAppearance)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        setStatusBarColor(viewController: self)
    }
}

// MARK: - CustomHeaderViewDelegate
extension TermsAndPrivacyViewController: CustomHeaderViewDelegate {
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
