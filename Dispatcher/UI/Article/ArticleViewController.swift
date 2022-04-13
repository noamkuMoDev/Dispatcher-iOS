import UIKit

class ArticleViewController: UIViewController {

    
    @IBOutlet weak var customHeader: CustomHeaderView!
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var favoriteIcon: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var topicButton: UIButton!
    
    let articleVM = ArticleViewModel()
    let cameFrom: String! = Constants.ScreenNames.HOMEPAGE
    var currentArticle = Article(id: "", articleTitle: "", date: "", url: "", content: "", author: "", topic: "", imageUrl: "", isFavorite: false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initiateUIElements()
        setGestureRecognizer()
    }
    
    func initiateUIElements() {
        customHeader.initView(delegate: self, apperanceType: .backOnlyAppearance)
        dateLabel.text = currentArticle.date
        titleLabel.text = currentArticle.articleTitle
        authorLabel.text = currentArticle.author
        contentLabel.text = currentArticle.content
        topicButton.setTitle(currentArticle.topic, for: .normal)
        if currentArticle.isFavorite {
            favoriteIcon.image = UIImage(named: "favoriteArticle-selected")
        }
        guard let url = URL(string: currentArticle.imageUrl!) else { return }
        UIImage.loadFrom(url: url) { image in
            self.articleImage.image = image
        }
    }
    
    
    func setGestureRecognizer() {
        favoriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: favoriteIcon, action: #selector(favoriteIconPressed)))
        favoriteIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteIconPressed(tapGestureRecognizer:)))
        favoriteIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    @objc func favoriteIconPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        
        if currentArticle.isFavorite { // current article IS Favorite
            
            // remove from CoreData + Firestore
            articleVM.removeArticleFromFavorites(articleID: currentArticle.id) { // works!
                
                self.currentArticle.isFavorite = false
                
                // send Notifications to: HomepageVC + FavoritesVC
                let dataDict:[String: String] = [
                    Constants.NotificationCenter.ARTICLE_ID: self.currentArticle.id,
                    Constants.NotificationCenter.IS_FAVORITE: "true",
                    Constants.NotificationCenter.SENDER: "ArticleViewController"
                ]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.ARTICLE_TO_HOMEPAGE), object: nil, userInfo: dataDict) // works!
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.ARTICLE_TO_FAVORITES), object: nil, userInfo: dataDict) // works!
                DispatchQueue.main.async {
                    self.favoriteIcon.image = UIImage(named: "favoriteArticle-notSelected")
                }
            }
           
        } else { // current article is NOT Favorite
            
            self.currentArticle.isFavorite = true
            
            // add to CoreData + Firestore
            articleVM.addArticleToFavorites(newArticle: currentArticle) { // works!
                
                // send Notifications to: HomepageVC + FavoritesVC
                let dataDict:[String: String] = [
                    Constants.NotificationCenter.ARTICLE_ID: self.currentArticle.id,
                    Constants.NotificationCenter.IS_FAVORITE: "false",
                    Constants.NotificationCenter.SENDER: "ArticleViewController"
                ]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.ARTICLE_TO_HOMEPAGE), object: nil, userInfo: dataDict) // works!
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationCenter.ARTICLE_TO_FAVORITES), object: nil, userInfo: dataDict) // works!
                DispatchQueue.main.async {
                    self.favoriteIcon.image = UIImage(named: "favoriteArticle-selected")
                }
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - CustomHeaderViewDelegate
extension ArticleViewController: CustomHeaderViewDelegate {
    
    func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
