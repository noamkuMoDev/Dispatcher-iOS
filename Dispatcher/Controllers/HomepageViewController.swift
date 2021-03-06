import UIKit

class HomepageViewController: UIViewController {
    
    /**Outlets**/
    
    
    /**Variables**/
    
    
    
    /**OnLoad**/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the header's buttons:
        configureItems()
        
        
        
        //Crash button
//        let button = UIButton(type: .roundedRect)
//        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
//        button.setTitle("Test Crash", for: [])
//        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//        view.addSubview(button)
        
    }
    
    //Crush button
//    @IBAction func crashButtonTapped(_ sender: UIButton) {
//        let numbers = [0]
//        let _ = numbers[1]
//    }
    
    
    
    
    
    /**Methods**/
    private func configureItems() {
        
        //Right header icons:
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
            )
        ]
        
        
        //dgdfdfdf
        
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
        
        
        //Left header icon - logo:
//        let customView = UIImageView(image: UIImage(named: "logo"))
//        customView.contentMode = .scaleAspectFit
//
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            customView: customView
//        )
    }
    
    
}

