import UIKit

class HeaderView: UIView {
    
    override init (frame:CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    convenience init () {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = hexStringToUIColor(hex: "#262146")
        let screenWidth = UIScreen.main.bounds.width
        let headerHeight:CGFloat = 64
        let headerWidthConstraint = widthAnchor.constraint(equalToConstant: screenWidth)
        let headerHeightConstraint = heightAnchor.constraint(equalToConstant: headerHeight)
        let constraints = [headerWidthConstraint,headerHeightConstraint]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    func setLogo() {
        
        let logo = UIImageView(image: UIImage(named:"logo")!)
        logo.translatesAutoresizingMaskIntoConstraints = false
        let logoWidthConstraint = logo.widthAnchor.constraint(equalToConstant: 50)
        let logoHeightConstraint = logo.heightAnchor.constraint(equalToConstant: 50)
        addSubview(logo)
        let stickLogoToLeft = logo.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16)
        let centerLogoVertically = logo.centerYAnchor.constraint(equalTo: centerYAnchor)
        let logoConstraint = [logoWidthConstraint,logoHeightConstraint, stickLogoToLeft, centerLogoVertically]
        NSLayoutConstraint.activate(logoConstraint)
        
        
    }
    
    func setBackButton() {
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        backButton.setTitle("Back", for: .normal)
        backButton.setImage(UIImage(systemName: "search"), for: .normal)
        backButton.addTarget(self, action: #selector(icon1Pressed), for: .touchUpInside)
        addSubview(backButton)
        let stickBtnToLeft = backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        let centerBtnVertically = backButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        let backBtnConstraint = [stickBtnToLeft, centerBtnVertically]
        NSLayoutConstraint.activate(backBtnConstraint)
    }
    
    
    func setIcons(_ icon1: UIImage, _ icon2: UIImage) {
        
        let leftIcon = UIButton()
        leftIcon.setImage(icon1, for: .normal)
        leftIcon.addTarget(self, action: #selector(icon1Pressed), for: .touchUpInside)
        leftIcon.imageView?.contentMode = .scaleAspectFill
        leftIcon.contentHorizontalAlignment = .fill
        leftIcon.contentVerticalAlignment = .fill
        
        let rightIcon = UIButton()
        rightIcon.setImage(icon2, for: .normal)
        rightIcon.addTarget(self, action: #selector(icon2Pressed), for: .touchUpInside)
        rightIcon.contentHorizontalAlignment = .fill
        rightIcon.contentVerticalAlignment = .fill
        
        let iconsStack = UIStackView(arrangedSubviews: [leftIcon ,rightIcon])
        iconsStack.distribution = .fillEqually
        iconsStack.axis = .horizontal
        iconsStack.spacing = 16
        iconsStack.translatesAutoresizingMaskIntoConstraints = false
        let iconsStackWidthConstraint = iconsStack.widthAnchor.constraint(equalToConstant: 66)
        let iconsStackHeightConstraint = iconsStack.heightAnchor.constraint(equalToConstant: 25)
        addSubview(iconsStack)
        let iconsStackRightConstraint  = iconsStack.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16)
        let iconsStackCenterVertically = iconsStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        let iconsStackConstraints = [iconsStackWidthConstraint,
                                     iconsStackHeightConstraint,
                                     iconsStackCenterVertically,
                                     iconsStackRightConstraint]
        NSLayoutConstraint.activate(iconsStackConstraints)
    }
    
    @objc func icon1Pressed() {
        print("icon1 was PRESSED")
    }
    
    @objc func icon2Pressed() {
        print("icon2 was PRESSED")
    }
}

