import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUIElements()
        viewModel.getUserSettingsPreferences()
    }
    

    func initializeUIElements() {
        customHeader.initView(delegate: self, apperanceType: .backOnlyAppearance)
        setupTableView()
    }
    

    func setupTableView() {
        tableView.register(UINib(nibName: Constants.NibNames.APP_SETTING, bundle: nil), forCellReuseIdentifier: Constants.TableCellsIdentifier.SETTING)
        tableView.register(UINib(nibName: Constants.NibNames.APP_SETTING_SECTION, bundle: nil), forHeaderFooterViewReuseIdentifier: Constants.TableCellsIdentifier.SETTING_SECTION)
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        setStatusBarColor(viewController: self, hexColor: "262146")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: false)
    }
}


// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.appSettings.count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = viewModel.sectionsSortedKeys[section]!
        return viewModel.appSettings[sectionKey]!.options.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableCellsIdentifier.SETTING, for: indexPath) as! AppSettingCell
        cell.delegate = self
        
        let sectionKey = viewModel.sectionsSortedKeys[indexPath.section]!
        var rowKey: String {
            switch sectionKey {
            case Constants.AppSettingsSectionTitles.SEARCH:
                if indexPath.row == 1 {
                    return Constants.AppSettings.SAVE_FILTERS
                } else {
                    return Constants.AppSettings.SEARCH_RESULTS
                }
            case Constants.AppSettingsSectionTitles.PREFERENCES:
                return Constants.AppSettings.NOTIFICATION
            default:
                return ""
            }
        }
        
        cell.settingTitle.text = viewModel.appSettings[sectionKey]!.options[rowKey]?.title
        cell.settingDescription.text = viewModel.appSettings[sectionKey]!.options[rowKey]?.description
        
        var settingSwitchImage: UIImage
        switch viewModel.appSettings[sectionKey]!.options[rowKey]?.status {
        case .on:
            settingSwitchImage = UIImage(named: "switch-on")!
            break
        case .off:
            settingSwitchImage = UIImage(named: "switch-off")!
            break
        default:
            settingSwitchImage = UIImage(named: "switch-disabled")!
            break
        }
        cell.settingSwitchImageView.image = settingSwitchImage
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableCellsIdentifier.SETTING_SECTION) as! SettingSectionCell
        view.sectionLabel.text = viewModel.sectionsSortedKeys[section]
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}

// MARK: - AppSettingCellDelegate
extension SettingsViewController: AppSettingCellDelegate {

    func settingCellDidPress(settingText: String) {
        
        viewModel.updateSetting(settingTitle: settingText) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - CustomHeaderViewDelegate
extension SettingsViewController: CustomHeaderViewDelegate {
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
