import UIKit

protocol SearchResultsViewDelegate {
    
}

class SearchResultsView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByView: UIView!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
       commonInit()
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    
    private func commonInit() {

        Bundle.main.loadNibNamed("SearchResultsView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
    }
    
}
