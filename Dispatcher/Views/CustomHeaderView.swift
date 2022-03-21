import UIKit

protocol CustomHeaderViewDelegate: AnyObject {
    func firstRightIconPressed()
    func secondRightIconPressed()
    func leftIconPressed()
}

extension CustomHeaderViewDelegate {
    func firstRightIconPressed() {}
    func secondRightIconPressed() {}
    func leftIconPressed() {}
}


class CustomHeaderView: UIView {
    
    @IBOutlet weak var firstRightImageView: UIImageView!
    @IBOutlet weak var secondRightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    
    private weak var delegate: CustomHeaderViewDelegate?

    
    func initView(delegate: CustomHeaderViewDelegate? = nil, icon1: UIImage? = nil, icon2: UIImage? = nil, leftIcon: UIImage? = nil) {
        
        commonInit()
        
        if let safeDelegate = delegate {
            self.delegate = safeDelegate
        }
        
        if let safeFirstRightIcon = icon1 {
            firstRightImageView.image = safeFirstRightIcon
            firstRightImageView.isHidden = false
        } else {
            firstRightImageView.isHidden = true
        }
        
        if let safeSecondRightIcon = icon2 {
            secondRightImageView.image = safeSecondRightIcon
            secondRightImageView.isHidden = false
        } else {
            secondRightImageView.isHidden = true
        }
        
        if let safeLeftIcon = leftIcon {
            leftImageView.image = safeLeftIcon
            leftImageView.isHidden = false
        } else {
            leftImageView.isHidden = true
        }
        
    }
    
    private func commonInit() {
    
        Bundle.main.loadNibNamed("CustomHeaderView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)

        firstRightImageView.addGestureRecognizer(UITapGestureRecognizer(target: firstRightImageView, action: #selector(farRightIconPressed)))
        firstRightImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(farRightIconPressed(tapGestureRecognizer:)))
        firstRightImageView.addGestureRecognizer(tapGestureRecognizer1)

        secondRightImageView.addGestureRecognizer(UITapGestureRecognizer(target: secondRightImageView, action: #selector(farRightIconPressed)))
        secondRightImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(scondRightIconPressed(tapGestureRecognizer:)))
        secondRightImageView.addGestureRecognizer(tapGestureRecognizer2)
        
        leftImageView.addGestureRecognizer(UITapGestureRecognizer(target: leftImageView, action: #selector(leftIconPressed)))
        leftImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(leftIconPressed(tapGestureRecognizer:)))
        leftImageView.addGestureRecognizer(tapGestureRecognizer3)
    }
    
    
    func updateIcons(rightIcon: UIImage, leftIcon: UIImage) {
        firstRightImageView.image = rightIcon
    
        leftImageView.image = leftIcon
        
        //TO DO: resize icons & change function fired
    }
    
    
    @objc func farRightIconPressed(tapGestureRecognizer: UITapGestureRecognizer)
    {
        delegate?.firstRightIconPressed()
    }
    
    @objc func scondRightIconPressed(tapGestureRecognizer: UITapGestureRecognizer)
    {
        delegate?.secondRightIconPressed()
    }
    
    @objc func leftIconPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.leftIconPressed()
    }
}
