import UIKit

class TermsAndPrivacyViewController: UIViewController {

    
    @IBOutlet weak var customHeader: CustomHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func viewWillDisppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}


// MARK: - CustomHeaderViewDelegate
extension TermsAndPrivacyViewController: CustomHeaderViewDelegate {
    
    func leftIconPressed() {
        navigationController?.popViewController(animated: true)
    }
}
