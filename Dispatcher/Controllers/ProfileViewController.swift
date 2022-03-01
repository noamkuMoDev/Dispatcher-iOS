import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(for: Constants.ScreenNames.profile, on: navigationController!.navigationBar)
    }
}
