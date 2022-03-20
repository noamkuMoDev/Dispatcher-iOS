import UIKit

protocol RecentSearchCellDelegate {
    func recentSearchPressed(called searchName: String)
    func removeCellButtonDidPress(called searchName: String)
}

class RecentSearchCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var removeIcon: UIImageView!
    
    var delegate: RecentSearchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
        
        
        label.addGestureRecognizer(UITapGestureRecognizer(target: label, action: #selector(itemLabelPressed)))
        label.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(itemLabelPressed(tapGestureRecognizer:)))
        label.addGestureRecognizer(tapGestureRecognizer1)
        
        removeIcon.addGestureRecognizer(UITapGestureRecognizer(target: removeIcon, action: #selector(removeItemPressed)))
        removeIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(removeItemPressed(tapGestureRecognizer:)))
        removeIcon.addGestureRecognizer(tapGestureRecognizer2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func itemLabelPressed(tapGestureRecognizer: UITapGestureRecognizer){
        delegate?.recentSearchPressed(called: label.text ?? "")
    }
    
    @objc func removeItemPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.removeCellButtonDidPress(called: label.text ?? "")
    }
}
