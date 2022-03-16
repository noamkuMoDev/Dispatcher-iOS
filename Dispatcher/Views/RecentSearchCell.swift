import UIKit

protocol removeRecentSearchCellDelegate {
    func removeCellButtonDidPress(called searchName: String)
}

class RecentSearchCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var removeIcon: UIImageView!
    
    var delegate: removeRecentSearchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
        
        removeIcon.addGestureRecognizer(UITapGestureRecognizer(target: removeIcon, action: #selector(removeItemPressed)))
        removeIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(removeItemPressed(tapGestureRecognizer:)))
        removeIcon.addGestureRecognizer(tapGestureRecognizer2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func removeItemPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.removeCellButtonDidPress(called: label.text ?? "")
    }
}
