import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var appSettings: [SettingModel] = [
        SettingModel(sectionTitle: "Search results", options: [
            SingleSetting(title: "Save filters", description: "Allow us to save filters when entering back to the app", status: .off),
            SingleSetting(title: "Save search results", description: "Allow us to save your search result preferences for next search", status: .off)
        ]),
        SettingModel(sectionTitle: "App preferences", options: [
            SingleSetting(title: "Notification", status: .on)
        ]),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.NibNames.appSetting, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.setting)
        tableView.register(UINib(nibName: Constants.NibNames.appSettingSection, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.TableCellsIdentifier.settingSection)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func viewWillDisppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return appSettings.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appSettings[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellsIdentifier.setting, for: indexPath) as! AppSettingCell
        
        cell.settingTitle.text = appSettings[indexPath.section].options[indexPath.row].title
        cell.settingDescription.text = appSettings[indexPath.section].options[indexPath.row].description
        
        var switchImage: UIImage
        switch appSettings[indexPath.section].options[indexPath.row].status {
        case .on:
            switchImage = UIImage(named: "switch-on")!
            break
        case .off:
            switchImage = UIImage(named: "switch-off")!
            break
        default:
            switchImage = UIImage(named: "switch-disabled")!
            break
        }
        cell.settingSwitchImageView.image = switchImage
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableCellsIdentifier.settingSection) as! SettingSectionCell
        view.sectionLabel.text = appSettings[section].sectionTitle
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}

// MARK: - CustomHeaderViewDelegate

extension SettingsViewController: CustomHeaderViewDelegate {
    
    func leftIconPressed() {
        navigationController?.popViewController(animated: true)
    }
}
