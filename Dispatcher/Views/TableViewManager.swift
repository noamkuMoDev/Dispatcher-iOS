import UIKit

//all types of custom cells (.xib)
enum CellTypes {
    case notification
    case savedArticle
    case article
    case setting
}

class TableViewManager<Model>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    var models: [Model]  // array of the data we present in the table
    private let cellType: CellTypes  // we return a cell of certain type
    private let reuseIdentifier: String  // identifier of the specific cell
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model], reuseIdentifier: String, cellType: CellTypes, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
        self.cellType = cellType
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row] // current object to print int the cell
        let cell: UITableViewCell
        switch cellType {
        case .notification:
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        case .savedArticle:
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SavedArticleCell
        case .article:
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NewsCell
        case .setting:
            cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! AppSettingCell
        }
        print("CELL CONFIGURATION")
        cellConfigurator(model, cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
