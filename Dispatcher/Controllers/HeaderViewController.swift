import UIKit

class HeaderViewController: UIViewController {

    lazy var headerView: HeaderView = {
        return HeaderView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        view.addSubview(headerView)
        let headerViewTopConstraint  = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let headerViewCenterXConstraint  = headerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let headerViewConstraints = [headerViewTopConstraint,headerViewCenterXConstraint]
        NSLayoutConstraint.activate(headerViewConstraints)
    }
    
    open func defineHeaderIcons(icon1: UIImage, icon2: UIImage) {
        headerView.setIcons(icon1, icon2)
    }
    
    open func defineHeaderLogo(){
        headerView.setLogo()
    }
}
