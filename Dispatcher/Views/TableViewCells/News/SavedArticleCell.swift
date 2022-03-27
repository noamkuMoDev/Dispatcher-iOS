import UIKit

class SavedArticleCell: UITableViewCell {
    
    @IBOutlet weak var savedArticleCell: UIView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleTopic: UIButton!
    @IBOutlet weak var articleMoreTags: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setCellBorder()
        setImageRounded()
        setCellColorsDesign()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    func setCellColorsDesign() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }
    
    func setCellBorder() {
        savedArticleCell.layer.borderWidth = 2
        let borderColor = UIColor( red: 243/255, green: 243/255, blue:255/255, alpha: 1.0 )
        savedArticleCell.layer.borderColor = borderColor.cgColor
        savedArticleCell.layer.cornerRadius =  4
    }
    
    func setImageRounded() {
        articleImage.clipsToBounds = true
        articleImage.layer.cornerRadius = 4
        articleImage.layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMinXMinYCorner,
            .layerMaxXMaxYCorner,
            .layerMaxXMinYCorner
        ]
    }
}
