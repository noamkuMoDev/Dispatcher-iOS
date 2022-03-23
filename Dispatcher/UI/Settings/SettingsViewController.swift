import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    let settingsVM = SettingsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUIElements()
    }
    
    func initializeUIElements() {
        customHeader.initView(delegate: self, leftIcon: UIImage(named: "BackButton"))
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.appSetting, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.setting)
        tableView.register(UINib(nibName: Constants.NibNames.appSettingSection, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.TableCellsIdentifier.settingSection)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsVM.appSettings.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsVM.appSettings[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellsIdentifier.setting, for: indexPath) as! AppSettingCell
        
        cell.settingTitle.text = settingsVM.appSettings[indexPath.section].options[indexPath.row].title
        cell.settingDescription.text = settingsVM.appSettings[indexPath.section].options[indexPath.row].description
        
        var switchImage: UIImage
        switch settingsVM.appSettings[indexPath.section].options[indexPath.row].status {
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
        view.sectionLabel.text = settingsVM.appSettings[section].sectionTitle
        
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
