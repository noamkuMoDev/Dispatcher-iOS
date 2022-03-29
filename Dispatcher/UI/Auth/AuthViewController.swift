import UIKit

enum SignupLoginPageCurrentView {
    case signup
    case login
}

class AuthViewController: UIViewController, LoadingViewDelegate {

    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailFormView: FormInputView!
    @IBOutlet weak var passwordFormView: FormInputView!
    @IBOutlet weak var reenterPasswordFormView: FormInputView!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var topButton: MainActionButtonView!
    @IBOutlet weak var bottomButton: MainActionButtonView!
    
    let viewModel = AuthViewModel()
    var currentPageType: SignupLoginPageCurrentView = .login
    
    var separatorConstraintLogin: NSLayoutConstraint? = nil
    var separatorConstraintSignup: NSLayoutConstraint? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recognizeUser()
        
        initializeUIElements()
        defineConstraints()
    }
    
    func recognizeUser() {

        startLoadingScreen()

        switch viewModel.checkIfLoggedIn() {
        case .loggedOut:
            currentPageType = .login
        case .loggedIn:
            DispatchQueue.main.async {
                self.navigateIntoApp()
                self.currentPageType = .login
            }
        }

        stopLoadingScreen()
    }
    
    func initializeUIElements() {
        
        emailFormView.initView(id: "email", delegate: self, labelText: "Invalid email adress", placeholderText: "Your Email", showIcon: true)
        passwordFormView.initView(id: "password", delegate: self, labelText: "Weak password", placeholderText: "Password")
        reenterPasswordFormView.initView(id: "re-password", delegate: self, labelText: "Input doesn't match previous password", placeholderText: "Re-Enter Password")
        loadingView.initView(delegate: self)
        loadingView.isHidden = true

        setActionButtons()

        let screenHeight = UIScreen.main.bounds.height
        logoImageView.heightAnchor.constraint(equalToConstant: CGFloat(screenHeight / 2 )).isActive = true

        
        if currentPageType == .login {
            setLoginPageLook()
        } else {
            setSignupPageLook()
        }
    }

    
    func setActionButtons() {
        topButton.delegate = self
        bottomButton.delegate = self
        
        topButton.buttonIcon.isHidden = false
        bottomButton.buttonIcon.isHidden = true
        bottomButton.entireButton.backgroundColor = UIColor.lightGray
    }

    
    func defineConstraints() {
        separatorConstraintSignup = separatorLine.topAnchor.constraint(equalTo: reenterPasswordFormView.bottomAnchor, constant: 25.0)
        separatorConstraintSignup?.isActive = true
        
        separatorConstraintLogin = separatorLine.topAnchor.constraint(equalTo: passwordFormView.bottomAnchor, constant: 50.0)
        separatorConstraintLogin?.isActive = false
    }

    
    func setSignupPageLook() {
        
        clearAllUIElements()
        currentPageType = .signup
        
        titleLabel.text = "Signup"

        reenterPasswordFormView.isHidden = false
        
        separatorConstraintLogin?.isActive = false
        separatorConstraintSignup?.isActive = true
        
        topButton.buttonLabel.text = "SIGNUP"
        bottomButton.buttonLabel.text = "LOGIN"
    }
    
    func setLoginPageLook() {
        
        clearAllUIElements()
        currentPageType = .login

        titleLabel.text = "Login"
        
        reenterPasswordFormView.isHidden = true

        separatorConstraintSignup?.isActive = false
        separatorConstraintLogin?.isActive = true
        
        topButton.buttonLabel.text = "LOGIN"
        bottomButton.buttonLabel.text = "SIGNUP"
    }
    
    func clearAllUIElements() {
        emailFormView.resetElements()
        passwordFormView.resetElements()
        reenterPasswordFormView.resetElements()
    }
    
    
    func signupNewUser() {
        startLoadingScreen()
        
        if reenterPasswordFormView.textField.text != passwordFormView.textField.text {
            reenterPasswordFormView.displayWarning()
        } else {
            let currentEmail = emailFormView.textField.text, currentPassword = passwordFormView.textField.text
            viewModel.validateSignUpFields(email: currentEmail, password: currentPassword, passwordAgain: reenterPasswordFormView.textField.text) { error, status in
                if !status {
                    print(error!)
                } else {
                    self.viewModel.signUserToApp(email: currentEmail!, password: currentPassword!) { error in
                        if let error = error {
                            print(error)
                        } else {
                            self.clearAllUIElements()
                            self.navigateIntoApp()
                        }
                    }
                }
            }
        }
        stopLoadingScreen()
    }
    
    func loginExistingUser() {
        startLoadingScreen()
        
        let email = emailFormView.textField.text, password = passwordFormView.textField.text
        var legitEmail = true, legitPassword = true
        if !viewModel.isValidEmailAddress(email: email ?? "") {
            emailFormView.displayWarning()
            legitEmail = false
        }
        if password == nil {
            passwordFormView.displayWarning()
        }

        if legitEmail && legitPassword {
            viewModel.logUserToApp(email: email!, password: password!) { error in
                if error != nil {
                    print(error!)
                } else {
                    self.clearAllUIElements()
                    self.navigateIntoApp()
                }
            }
        }
        stopLoadingScreen()
    }
    
    func navigateIntoApp() {
        let homepage = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyTabBarController")
        self.present(homepage, animated: true, completion: nil)
    }
    
    func startLoadingScreen() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingView.loadIndicator.startAnimating()
        }
    }
    
    func stopLoadingScreen() {
        DispatchQueue.main.async {
            self.loadingView.loadIndicator.stopAnimating()
            self.loadingView.isHidden = true
        }
    }
}


// MARK: - FormInputViewDelegate
extension AuthViewController: FormInputViewDelegate {
    
    // V
    func textFieldDidChange(textFieldId: String, currentText: String?) {
        
        if currentPageType == .signup {
            if textFieldId == "email" {
                if currentText != nil && currentText!.count > 5 {
                    if !viewModel.isValidEmailAddress(email: currentText!) {
                        emailFormView.displayWarning()
                    } else {
                        emailFormView.hideWarning()
                    }
                }
            } else if textFieldId == "password" {
                let isPasswordStrong = viewModel.isStrongPassword(password: currentText ?? "")
                if !isPasswordStrong {
                    passwordFormView.displayWarning()
                } else {
                    passwordFormView.hideWarning()
                }
            } else { //textFieldId == "re-password"
                if currentText != nil && currentText!.count > 5 {
                    if currentText != passwordFormView.textField.text {
                        reenterPasswordFormView.displayWarning()
                    } else {
                        reenterPasswordFormView.hideWarning()
                    }
                }
            }
        }
    }
}



// MARK: - MainActionButtonDelegate
extension AuthViewController: MainActionButtonDelegate {
    
    // V
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
