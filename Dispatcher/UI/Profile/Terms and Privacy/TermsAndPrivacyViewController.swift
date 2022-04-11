import UIKit

class TermsAndPrivacyViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
    }
    
    // 11/4/22 V
    func initiateUIElements() {
        customHeader.initView(delegate: self, apperanceType: .backOnlyAppearance)
    }
    
    // 11/4/22 V
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


// MARK: - CustomHeaderViewDelegate
extension TermsAndPrivacyViewController: CustomHeaderViewDelegate {
    
    // 11/4/22 V
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
