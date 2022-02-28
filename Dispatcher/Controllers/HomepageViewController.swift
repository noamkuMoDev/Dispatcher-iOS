import UIKit

class HomepageViewController: UIViewController {
    
//    enum Environment: String { // 1
//        case debugDevelopment = "Dev"
//        case releaseDevelopment = "ReleaseDev"
//
//        case debugProduction = "DebugProd"
//        case releaseProduction = "ReleaseProd"
//    }
//
//    class BuildConfiguration { // 2
//        static let shared = BuildConfiguration()
//
//        var environment: Environment
//
//        init() {
//            let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
//
//            environment = Environment(rawValue: currentConfiguration)!
//        }
//    }
    
    
    /**Outlets**/
    
    
    /**Variables**/
    
    
    
    /**OnLoad**/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the header's buttons:
        configureItems()
        
        //print("Current configuration: \(BuildConfiguration.shared.environment)")
        
        
        //Crash button
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    //Crush button
    @IBAction func crashButtonTapped(_ sender: UIButton) {
        let numbers = [0]
        let _ = numbers[1]
    }
    
    
    
    
    
    /**Methods**/
    private func configureItems() {
        
        let avatar = UIButton(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
        avatar.setTitle("NK", for: .normal)
        avatar.backgroundColor = .gray
        avatar.layer.cornerRadius = avatar.frame.width / 2
        avatar.layer.masksToBounds = true
        
        //Right side icons:
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "bell"),
                style: .done,
                target: self,
                action: nil
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .done,
                target: self,
                action: nil
            ),
            UIBarButtonItem(
            customView: avatar
            )
        ]
        
        
        //Left side logo:
        let logoImage = UIImage.init(named: "logo")
        let logoImageView = UIImageView.init(image: logoImage)
        //logoImageView.frame = CGRect(x:0.0,y:0.0, width:10,height:25.0)
        logoImageView.contentMode = .scaleAspectFill
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
        let widthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 60)
        let heightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 60)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        navigationItem.leftBarButtonItem =  imageItem

    }
    
    
}

