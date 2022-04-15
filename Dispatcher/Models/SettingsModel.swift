import Foundation

struct SettingModel {
    var sectionTitle: String
    var options: [String:SingleSetting]
}

struct SingleSetting {
    var title: String
    var description: String
    var status: SwitchStatus
}

enum SwitchStatus: Int {
    case disabled // index 0
    case on //index 1
    case off //index 2
    
    static var allCases: [SwitchStatus] = [.disabled, .on, .off]
    
    var title: String {
        switch self {
        case .disabled:
            return "disabled"
        case .on:
            return "on"
        case .off:
            return "off"
        }
    }
}

