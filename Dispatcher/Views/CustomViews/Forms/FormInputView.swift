import UIKit

protocol FormInputViewDelegate {
    func textFieldDidChange(textFieldId: String, currentText: String?)
}


enum eyeIconStatus {
    case conseal
    case reveal
}

class FormInputView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var textfieldIcon: UIImageView!
    
    
    var delegate: FormInputViewDelegate?
    var id: String = ""
    var eyeIconStatus: eyeIconStatus = .conseal
    
    
    func initView(id: String, delegate: FormInputViewDelegate? = nil, labelText: String = "", placeholderText: String = "", showIcon: Bool = false) {
        
        commonInit()
        
        self.id = id
        if let safeDelegate = delegate {
            self.delegate = safeDelegate
        }
        textField.placeholder = placeholderText
        textField.addTarget(self, action: #selector(FormInputView.textFieldDidChange(_:)), for: .editingChanged)
        textfieldIcon.isHidden = showIcon
        warningLabel.text = labelText
        warningLabel.isHidden = true
    }
    
    private func commonInit() {
        
        Bundle.main.loadNibNamed("FormInputView", owner: self, options: nil)
        contentView.frame = self.bounds
        self.addSubview(contentView)
        
        setTextFieldDesign()
        defineGestureRecognizers()
    }
    
    private func setTextFieldDesign() {
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 0.0
        textField.layer.cornerRadius = 4.0
    }
    
    private func defineGestureRecognizers() {
        textfieldIcon.addGestureRecognizer(UITapGestureRecognizer(target: textfieldIcon, action: #selector(iconPressed)))
        textfieldIcon.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(iconPressed(tapGestureRecognizer:)))
        textfieldIcon.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func iconPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        if !textfieldIcon.isHidden {
            if eyeIconStatus == .conseal {
                eyeIconStatus = .reveal
                textfieldIcon.image = UIImage(named: "eye-icon-reveal")
                textField.isSecureTextEntry = false
            } else {
                eyeIconStatus = .conseal
                textfieldIcon.image = UIImage(named: "eye-icon-conseal")
                textField.isSecureTextEntry = true
            }
        }
    }
    
    func displayWarning() {
        textField.layer.borderWidth = 1.0
        warningLabel.isHidden = false
    }
    
    func hideWarning() {
        textField.layer.borderWidth = 0.0
        warningLabel.isHidden = true
    }
    
    func resetElements() {
        eyeIconStatus = .conseal
        textfieldIcon.image = UIImage(named: "eye-icon-conseal")
        
        textField.text = nil
        if !textfieldIcon.isHidden {
            textField.isSecureTextEntry = true
        }
        textField.layer.borderWidth = 0.0
        
        warningLabel.isHidden = true
    }
}

extension FormInputView: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            hideWarning()
        } else {
            delegate?.textFieldDidChange(textFieldId: id , currentText: textField.text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}