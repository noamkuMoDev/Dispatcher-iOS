import UIKit

class AppSettingCell: UITableViewCell {

    @IBOutlet weak var settingTitle: UILabel!
    @IBOutlet weak var settingDescription: UILabel!
    @IBOutlet weak var settingSwitchImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let attributedString = NSMutableAttributedString(string: settingDescription.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        settingDescription.attributedText = attributedString
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
