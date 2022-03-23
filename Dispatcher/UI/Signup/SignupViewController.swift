import UIKit

enum eyeIconStatus {
    case conseal
    case reveal
}

class SignupViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var wrongEmailLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordEyeIcon: UIImageView!
    @IBOutlet weak var weakPasswordLabel: UILabel!
    
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var reenterPasswordEyeIcon: UIImageView!
    @IBOutlet weak var mismatchPasswordLabel: UILabel!
    
    @IBOutlet weak var signupButton: MainActionButtonView!
    @IBOutlet weak var loginButton: MainActionButtonView!
    
    
    let signupVM = SignupViewModel()
    
    var passwordEyeStatus: eyeIconStatus = .conseal
    var reenterPasswordEyeStatus: eyeIconStatus = .conseal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeUIElements()
        defineGestureRecognizers()
    }
    
    func initializeUIElements() {
        showHideElements()
        
        //  TO DO: change the uiimageview height to be screenHeight / 3
        //  logoImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)

        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(SignupViewController.textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor.red.cgColor
        emailTextField.layer.borderWidth = 0.0
        
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(SignupViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 0.0
        
        reenterPasswordTextField.delegate = self
        reenterPasswordTextField.addTarget(self, action: #selector(SignupViewController.textFieldDidChange(_:)), for: .editingChanged)
        reenterPasswordTextField.layer.masksToBounds = true
        reenterPasswordTextField.layer.borderColor = UIColor.red.cgColor
        reenterPasswordTextField.layer.borderWidth = 0.0
    }
    
    func defineGestureRecognizers() {
        passwordEyeIcon.addGestureRecognizer(UITapGestureRecognizer(target: passwordEyeIcon, action: #selector(passwordIconTapped)))
        passwordEyeIcon.isUserInteractionEnabled = true
                let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(passwordIconTapped(tapGestureRecognizer:)))
        passwordEyeIcon.addGestureRecognizer(tapGestureRecognizer1)
        
        reenterPasswordEyeIcon.addGestureRecognizer(UITapGestureRecognizer(target: passwordEyeIcon, action: #selector(reenterPasswordIconTapped)))
        reenterPasswordEyeIcon.isUserInteractionEnabled = true
                let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(reenterPasswordIconTapped(tapGestureRecognizer:)))
        reenterPasswordEyeIcon.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    func showHideElements() {
        wrongEmailLabel.isHidden = true
        weakPasswordLabel.isHidden = true
        mismatchPasswordLabel.isHidden = true
    }
    
    
    
    @objc func passwordIconTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if passwordEyeStatus == .conseal {
            passwordEyeStatus = .reveal
            passwordEyeIcon.image = UIImage(named: "eye-icon-reveal")
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordEyeStatus = .conseal
            passwordEyeIcon.image = UIImage(named: "eye-icon-conseal")
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @objc func reenterPasswordIconTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if reenterPasswordEyeStatus == .conseal {
            reenterPasswordEyeStatus = .reveal
            reenterPasswordEyeIcon.image = UIImage(named: "eye-icon-reveal")
            reenterPasswordTextField.isSecureTextEntry = false
        } else {
            reenterPasswordEyeStatus = .conseal
            reenterPasswordEyeIcon.image = UIImage(named: "eye-icon-conseal")
            reenterPasswordTextField.isSecureTextEntry = true
        }
    }
    
    
    
    func signupButtonPressed() {
        
        if reenterPasswordTextField.text != passwordTextField.text {
            mismatchPasswordLabel.isHidden = false
            reenterPasswordTextField.layer.borderWidth = 1.0
        } else {
            let currentEmail = emailTextField.text, currentPassword = passwordTextField.text
            if signupVM.validateSignUpFields(email: currentEmail, password: currentPassword, passwordAgain: reenterPasswordTextField.text) {
                signupVM.signUserToApp(email: currentEmail!, password: currentPassword!)
            } else {
                // 1 or more fields don't fit requirements
            }
        }
    }
    
    
    func loginButtonPressed() {
        self.performSegue(withIdentifier: Constants.Segues.signupToLogin, sender: self)
    }
}


extension SignupViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == emailTextField {
            if emailTextField.text != nil && emailTextField.text!.count > 5 {
                if !signupVM.isValidEmailAddress(email: emailTextField.text!) {
                    wrongEmailLabel.isHidden = false
                    emailTextField.layer.borderWidth = 1.0
                } else {
                    wrongEmailLabel.isHidden = true
                    emailTextField.layer.borderWidth = 0.0
                }
            }
        }
        
        if textField == passwordTextField {
            let isPasswordStrong = signupVM.isStrongPassword(password: passwordTextField.text ?? "")
            if !isPasswordStrong {
                weakPasswordLabel.isHidden = false
                passwordTextField.layer.borderWidth = 1.0
            } else {
                weakPasswordLabel.isHidden = true
                passwordTextField.layer.borderWidth = 0.0
            }
        }
    }
}
