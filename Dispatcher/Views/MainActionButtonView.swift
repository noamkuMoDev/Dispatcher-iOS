import UIKit

class MainActionButtonView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = bounds
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MainActionButtonView", owner: self, options: nil)
        addSubview(contentView)
        contentView.layer.cornerRadius = contentView.frame.size.height / 2
        contentView.clipsToBounds = true
    }
}
