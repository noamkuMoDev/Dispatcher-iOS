import UIKit

protocol AppSettingCellDelegate {
    func settingCellDidPress(settingText: String)
}

class AppSettingCell: UITableViewCell {

    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var settingDescription: UILabel!
    @IBOutlet weak var settingSwitchImageView: UIImageView!
    
    var delegate: AppSettingCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setTextLineSpacing()
        setCellColorDesign()
        setGestureRecognizer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    // 11/4/22 V
    func setTextLineSpacing() {
        let attributedString = NSMutableAttributedString(string: settingDescription.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        settingDescription.attributedText = attributedString
    }
    
    
    // 11/4/22 V
    func setCellColorDesign() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }
    
    
    // 11/4/22 V
    func setGestureRecognizer() {
        settingSwitchImageView.addGestureRecognizer(UITapGestureRecognizer(target: settingSwitchImageView, action: #selector(switchWasPressed)))
        settingSwitchImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchWasPressed(tapGestureRecognizer:)))
        settingSwitchImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // 11/4/22 V
    @objc func switchWasPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.settingCellDidPress(settingText: settingTitle.text!)
    }
}
