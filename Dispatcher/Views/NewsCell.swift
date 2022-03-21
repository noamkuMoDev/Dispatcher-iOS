import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var entireNewsCell: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var subjectTag: UIButton!
    @IBOutlet weak var moreSubjectsTag: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        entireNewsCell.layer.cornerRadius = 20
        entireNewsCell.layer.borderWidth = 2
        let borderColor = UIColor( red: 243/255, green: 243/255, blue:255/255, alpha: 1.0 )
        entireNewsCell.layer.borderColor = borderColor.cgColor
        
        newsImage.clipsToBounds = true
        newsImage.layer.cornerRadius = 10
        newsImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        subjectTag.layer.cornerRadius = subjectTag.frame.size.height / 2
        subjectTag.clipsToBounds = true
        moreSubjectsTag.layer.cornerRadius = moreSubjectsTag.frame.size.height / 2
        moreSubjectsTag.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
}
