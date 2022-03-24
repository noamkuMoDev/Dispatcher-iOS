import UIKit

class TermsAndPrivacyViewController: UIViewController {

    
    @IBOutlet weak var customHeader: CustomHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateUIElements()
    }
    
    func initiateUIElements() {
        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


// MARK: - CustomHeaderViewDelegate
extension TermsAndPrivacyViewController: CustomHeaderViewDelegate {
    
    func leftIconPressed() {
        navigationController?.popViewController(animated: true)
    }
}
