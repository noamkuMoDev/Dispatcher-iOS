import UIKit

class CustomHeaderView: UIView {


    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var rightSideFirst: UIImageView!
    @IBOutlet weak var rightSideSecond: UIImageView!
    
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
        }
}
