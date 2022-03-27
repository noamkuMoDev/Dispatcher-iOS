import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var entireNewsCell: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectTag: UIButton!
    @IBOutlet weak var moreSubjectsTag: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setCellBorder()
        setCellColorsDesign()
        setImageRounded()
        setTagsRounded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    
    func setCellColorsDesign() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }
    
    func setCellBorder() {
        entireNewsCell.layer.cornerRadius = 20
        entireNewsCell.layer.borderWidth = 2
        let borderColor = UIColor( red: 243/255, green: 243/255, blue:255/255, alpha: 1.0 )
        entireNewsCell.layer.borderColor = borderColor.cgColor
    }
    
    func setImageRounded() {
        newsImage.clipsToBounds = true
        newsImage.layer.cornerRadius = 10
        newsImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setTagsRounded() {
        subjectTag.layer.cornerRadius = subjectTag.frame.size.height / 2
        subjectTag.clipsToBounds = true
        moreSubjectsTag.layer.cornerRadius = moreSubjectsTag.frame.size.height / 2
        moreSubjectsTag.clipsToBounds = true
    }
}
