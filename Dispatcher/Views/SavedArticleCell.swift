import UIKit

class SavedArticleCell: UITableViewCell {

    @IBOutlet weak var savedArticleCell: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        savedArticleCell.layer.cornerRadius =  10
        
        savedArticleCell.layer.borderWidth = 2
        let borderColor = UIColor( red: 243/255, green: 243/255, blue:255/255, alpha: 1.0 )
        savedArticleCell.layer.borderColor = borderColor.cgColor
    }
}
