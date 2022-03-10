import UIKit

protocol CustomHeaderViewDelegate: AnyObject {
    func btnWasPressed()
}

class CustomHeaderView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var rightSideFirst: UIImageView!
    @IBOutlet weak var rightSideSecond: UIImageView!
    
    weak var delegate: CustomHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CustomHeaderView", owner: self, options: nil)
        addSubview(contentView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        rightSideFirst.isUserInteractionEnabled = true
        rightSideFirst.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("Clicked notifications")
        // Your action
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        delegate?.btnWasPressed()
    }
}
