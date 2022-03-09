import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var entireNewsCell: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var subjectTag: UIButton!
    @IBOutlet weak var moreSubjectsTag: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        subjectTag.layer.cornerRadius = subjectTag.frame.size.height / 2
        subjectTag.clipsToBounds = true
        moreSubjectsTag.layer.cornerRadius = moreSubjectsTag.frame.size.height / 2
        moreSubjectsTag.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        entireNewsCell.layer.cornerRadius = 20
        
        newsImage.clipsToBounds = true
        newsImage.layer.cornerRadius = 10
        newsImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
}
