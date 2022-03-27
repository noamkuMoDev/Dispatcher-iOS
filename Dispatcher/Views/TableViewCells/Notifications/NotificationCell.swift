import UIKit

protocol NotificationCellDelegate {
    func notificationDidPress(notificationText: String)
}

class NotificationCell: UITableViewCell {
    
    
    @IBOutlet weak var entireCell: UIView!
    @IBOutlet weak var verticalLine: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var delegate: NotificationCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setGestureRecognizers()
        setCellColorDesign()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setGestureRecognizers() {
        entireCell.addGestureRecognizer(UITapGestureRecognizer(target: entireCell, action: #selector(notificationCellTapped)))
        entireCell.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(notificationCellTapped(tapGestureRecognizer:)))
        entireCell.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func setCellColorDesign() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }
    
    @objc func notificationCellTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.notificationDidPress(notificationText: label.text!)
    }
}
