import UIKit

enum eyeIconStatus {
    case conseal
    case reveal
}

enum SignupLoginPageCurrentView {
    case signup
    case login
}

class AuthViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var wrongEmailLabel: UILabel!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordEyeIcon: UIImageView!
    @IBOutlet weak var weakPasswordLabel: UILabel!
    
    @IBOutlet weak var reenterPasswordTextField: UITextField!
    @IBOutlet weak var reenterPasswordEyeIcon: UIImageView!
    @IBOutlet weak var mismatchPasswordLabel: UILabel!
    
    @IBOutlet weak var separatorLine: UIView!
    
    @IBOutlet weak var topButton: MainActionButtonView!
    @IBOutlet weak var bottomButton: MainActionButtonView!
    
    
    
    let viewModel = AuthViewModel()
    var currentPageType: SignupLoginPageCurrentView = .signup
    var passwordEyeStatus: eyeIconStatus = .conseal
    var reenterPasswordEyeStatus: eyeIconStatus = .conseal
    
    var separatorConstraintLogin: NSLayoutConstraint? = nil
    var separatorConstraintSignup: NSLayoutConstraint? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recognizeUser()
        initializeUIElements()
        defineGestureRecognizers()
        
        separatorConstraintSignup = separatorLine.topAnchor.constraint(equalTo: mismatchPasswordLabel.bottomAnchor, constant: 25.0)
        separatorConstraintSignup?.isActive = true
        
        separatorConstraintLogin = separatorLine.topAnchor.constraint(equalTo: weakPasswordLabel.bottomAnchor, constant: 50.0)
        separatorConstraintLogin?.isActive = false
    }
    
    func recognizeUser() {
        if true { //if user is not recognized automatically
            currentPageType = .signup
        } else {
            currentPageType = .login
        }
    }
    
    func initializeUIElements() {
        showHideElements()
        setTextFields()
        setActionButtons()
        //  TO DO: change the uiimageview height to be screenHeight / 3
        let screenHeight = UIScreen.main.bounds.height
        logoImageView.heightAnchor.constraint(equalToConstant: CGFloat(screenHeight / 2 )).isActive = true

        
        if currentPageType == .login {
            setLoginPageLook()
        } else {
            setSignupPageLook()
        }
    }
    
    func showHideElements() {
        wrongEmailLabel.isHidden = true
        weakPasswordLabel.isHidden = true
        mismatchPasswordLabel.isHidden = true
    }
    
    func setTextFields() {
        emailTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(AuthViewController.textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderColor = UIColor.red.cgColor
        emailTextField.layer.borderWidth = 0.0
        emailTextField.layer.cornerRadius = 4.0
        
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(AuthViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 0.0
        passwordTextField.layer.cornerRadius = 4.0
        
        reenterPasswordTextField.delegate = self
        reenterPasswordTextField.addTarget(self, action: #selector(AuthViewController.textFieldDidChange(_:)), for: .editingChanged)
        reenterPasswordTextField.layer.masksToBounds = true
        reenterPasswordTextField.layer.borderColor = UIColor.red.cgColor
        reenterPasswordTextField.layer.borderWidth = 0.0
        reenterPasswordTextField.layer.cornerRadius = 4.0
    }
    
    func setActionButtons() {
        topButton.delegate = self
        bottomButton.delegate = self
        
        topButton.buttonIcon.isHidden = false
        bottomButton.buttonIcon.isHidden = true
        bottomButton.entireButton.backgroundColor = UIColor.lightGray
    }
    
    func defineGestureRecognizers() {
        
        let iconPress1 = MyTapGesture(target: self, action: #selector(self.eyeIconWasTapped))
        iconPress1.sender = "enter"
        passwordEyeIcon.isUserInteractionEnabled = true
        passwordEyeIcon.addGestureRecognizer(iconPress1)
        
        let iconPress2 = MyTapGesture(target: self, action: #selector(self.eyeIconWasTapped))
        iconPress2.sender = "re-enter"
        reenterPasswordEyeIcon.isUserInteractionEnabled = true
        reenterPasswordEyeIcon.addGestureRecognizer(iconPress2)
    }
    
    @objc func eyeIconWasTapped(sender : MyTapGesture) {
        
        if sender.sender == "enter" {
            if passwordEyeStatus == .conseal {
                passwordEyeStatus = .reveal
                passwordEyeIcon.image = UIImage(named: "eye-icon-reveal")
                passwordTextField.isSecureTextEntry = false
            } else {
                passwordEyeStatus = .conseal
                passwordEyeIcon.image = UIImage(named: "eye-icon-conseal")
                passwordTextField.isSecureTextEntry = true
            }
        } else {
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
    }
    
    func setSignupPageLook() {
        currentPageType = .signup
        // title
        titleLabel.text = "Signup"
        
        //clear text fields
        clearAllUIElements()
        
        // extra text field
        reenterPasswordTextField.isHidden = false
        reenterPasswordEyeIcon.isHidden = false
        
        //change separator location
        separatorConstraintLogin?.isActive = false
        separatorConstraintSignup?.isActive = true
        
        // buttons
        topButton.buttonLabel.text = "SIGNUP"
        bottomButton.buttonLabel.text = "LOGIN"
    }
    
    func setLoginPageLook() {
        currentPageType = .login
        // title
        titleLabel.text = "Login"
        
        //clear text fields
        clearAllUIElements()
        
        // remove extra text field
        reenterPasswordTextField.isHidden = true
        reenterPasswordEyeIcon.isHidden = true

        //change separator location
        separatorConstraintSignup?.isActive = false
        separatorConstraintLogin?.isActive = true
        
        // buttons
        topButton.buttonLabel.text = "LOGIN"
        bottomButton.buttonLabel.text = "SIGNUP"
    }
    
    func clearAllUIElements() {
        emailTextField.text = nil
        passwordTextField.text = nil
        reenterPasswordTextField.text = nil
        
        passwordEyeStatus = .conseal
        passwordEyeIcon.image = UIImage(named: "eye-icon-conseal")
        passwordTextField.isSecureTextEntry = true
        reenterPasswordEyeStatus = .conseal
        reenterPasswordEyeIcon.image = UIImage(named: "eye-icon-conseal")
        reenterPasswordTextField.isSecureTextEntry = true
        
        emailTextField.layer.borderWidth = 0.0
        passwordTextField.layer.borderWidth = 0.0
        reenterPasswordTextField.layer.borderWidth = 0.0
        
        wrongEmailLabel.isHidden = true
        weakPasswordLabel.isHidden = true
        mismatchPasswordLabel.isHidden = true
    }
    
    
    func signupNewUser() {
    
        if reenterPasswordTextField.text != passwordTextField.text {
            mismatchPasswordLabel.isHidden = false
            reenterPasswordTextField.layer.borderWidth = 1.0
        } else {
            let currentEmail = emailTextField.text, currentPassword = passwordTextField.text
            viewModel.validateSignUpFields(email: currentEmail, password: currentPassword, passwordAgain: reenterPasswordTextField.text) { error, status in
                if !status {
                    print(error!)
                } else {
                    self.viewModel.signUserToApp(email: self.emailTextField.text!, password: self.passwordTextField.text!) { error in
                        if error != nil {
                            print(error!)
                        } else {
                            self.performSegue(withIdentifier: Constants.Segues.AUTH_SCREEN_TO_APP, sender: self)
                        }
                    }
                }
            }
        }
    }
    
    func loginExistingUser() {
        
        var legitEmail = true, legitPassword = true
        if !viewModel.isValidEmailAddress(email: emailTextField.text ?? "") {
            emailTextField.layer.borderWidth = 1.0
            wrongEmailLabel.isHidden = false
            legitEmail = false
        }
        if passwordTextField.text == nil {
            passwordTextField.layer.borderWidth = 1.0
            legitPassword = false
        }
        
        if legitEmail && legitPassword {
            viewModel.logUserToApp(email: emailTextField.text!, password: passwordTextField.text!) { error in
                if error != nil {
                    print(error!)
                } else {
                    self.performSegue(withIdentifier: Constants.Segues.AUTH_SCREEN_TO_APP, sender: self)
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == emailTextField {
            if emailTextField.text != nil && emailTextField.text!.count > 5 {
                if !viewModel.isValidEmailAddress(email: emailTextField.text ?? "") {
                    wrongEmailLabel.isHidden = false
                    emailTextField.layer.borderWidth = 1.0
                } else {
                    wrongEmailLabel.isHidden = true
                    emailTextField.layer.borderWidth = 0.0
                }
            }
        }
        
        if textField == passwordTextField {
            let isPasswordStrong = viewModel.isStrongPassword(password: passwordTextField.text ?? "")
            if !isPasswordStrong {
                weakPasswordLabel.isHidden = false
                passwordTextField.layer.borderWidth = 1.0
            } else {
                weakPasswordLabel.isHidden = true
                passwordTextField.layer.borderWidth = 0.0
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}


// MARK: - MainActionButtonDelegate
extension AuthViewController: MainActionButtonDelegate {
    
    func actionButtonDidPress(btnText: String) {

        switch btnText {
        case "LOGIN":
            if currentPageType == .login {
                loginExistingUser()
            } else {
                setLoginPageLook()
            }
        case "SIGNUP":
            if currentPageType == .login {
                setSignupPageLook()
            } else {
                signupNewUser()
            }
        default:
            print("not optional")
        }
    }
}



class MyTapGesture: UITapGestureRecognizer {
    var sender = String()
}
