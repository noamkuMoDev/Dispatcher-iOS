import UIKit

class SavedArticleCell: UITableViewCell {
    
    @IBOutlet weak var savedArticleCell: UIView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        savedArticleCell.layer.cornerRadius =  4
        
        savedArticleCell.layer.borderWidth = 2
        let borderColor = UIColor( red: 243/255, green: 243/255, blue:255/255, alpha: 1.0 )
        savedArticleCell.layer.borderColor = borderColor.cgColor
        
        articleImage.clipsToBounds = true
        articleImage.layer.cornerRadius = 4
        articleImage.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMaxYCorner,
            .layerMaxXMinYCorner
        ]
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
}
