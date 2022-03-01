import UIKit

class HomepageViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(for: Constants.ScreenNames.homepage, on: navigationController!.navigationBar)
    }
}
