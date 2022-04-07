import UIKit

class ViewProfileViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var changePictureLabel: UILabel!
    
    @IBOutlet weak var nameInputView: FormInputView!
    @IBOutlet weak var emailInputView: FormInputView!
    
    @IBOutlet weak var darkBackgroundView: UIView!
    @IBOutlet weak var popupView: ActionPopupView!
    
    
    var newProfilePicture: UIImage? = nil
    var existingProfilePicture: UIImage? = nil
    var userName: String = "Noam Kurtzer"
    var userEmail: String = "noamkurtzer@gmail.com"
    var newEmail: String?
    var newName: String?
    
    let viewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserDetails()
        initializeUIElements()
    }
    
    func fetchUserDetails() {
        viewModel.fetchUserDetails() { userName, userEmail, userImage in
            if let userName = userName {
                self.userName = userName
            }
            if let userEmail = userEmail {
                self.userEmail = userEmail
            }
            if let userImage = userImage {
                let retrievedImg = UIImage(data: userImage as Data)
                self.existingProfilePicture = retrievedImg
                self.setupUserProfilePicture(image: retrievedImg!)
            }
        }
    }
    
    func initializeUIElements() {
        customHeader.initView(delegate: self, apperanceType: .backOnlyAppearance)
        popupView.initView(delegate: self)
        initTextInputs()
        userPicture.layer.cornerRadius = userPicture.frame.width / 2
        userPicture.layer.masksToBounds = true
        stopEditingProfileUI()
        hideAlert()
    }
    
    // TO DO : move ids to Constants file + in FormInputView in textFieldDidChange
    func initTextInputs() {
        nameInputView.initView(id: "name", delegate: self, labelText: "Invalid name", placeholderText: "", hideIcon: true)
        emailInputView.initView(id: "userEmail", delegate: self, labelText: "Invalid email", placeholderText: "", hideIcon: true)
        nameInputView.textField.text = userName
        emailInputView.textField.text = userEmail
        nameInputView.contentView.backgroundColor = .white
        emailInputView.contentView.backgroundColor = .white
    }
    
    func setupUserProfilePicture(image: UIImage?) {
        if let image = image {
            userPicture.image = image
        }
    }
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        customHeader.updateHeaderAppearanceType(to: .confirmCancelAppearance)
        startEditingProfileUI()
        nameInputView.displayEditMode()
        emailInputView.displayEditMode()
        defineGestureRecognizers()
    }
    
    func defineGestureRecognizers() {
        changePictureLabel.addGestureRecognizer(UITapGestureRecognizer(target: changePictureLabel, action: #selector(changePicturePressed)))
        changePictureLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(changePicturePressed(tapGestureRecognizer:)))
        changePictureLabel.addGestureRecognizer(tapGestureRecognizer1)
        
        darkBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: darkBackgroundView, action: #selector(dismissPopup)))
        darkBackgroundView.isUserInteractionEnabled = true
               let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(dismissPopup(tapGestureRecognizer:)))
        darkBackgroundView.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    @objc func changePicturePressed(tapGestureRecognizer: UITapGestureRecognizer) {
        popupView.reArrangePopupView(toState: .selectPictureFrom)
        displayAlert()
    }
    
    func displayImagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
   
    
    
    func displayAlert() {
        darkBackgroundView.isHidden = false
        popupView.isHidden = false
    }
    
    func hideAlert() {
        darkBackgroundView.isHidden = true
        popupView.isHidden = true
    }
    
    func startEditingProfileUI() {
        screenTitle.isHidden = true
        editProfileButton.isHidden = true
        changePictureLabel.isHidden = false
        nameInputView.textField.isEnabled = true
        emailInputView.textField.isEnabled = true
    }
    
    func stopEditingProfileUI() {
        screenTitle.isHidden = false
        editProfileButton.isHidden = false
        changePictureLabel.isHidden = true
        nameInputView.textField.isEnabled = false
        emailInputView.textField.isEnabled = false
        nameInputView.dismissEditMode()
        emailInputView.dismissEditMode()
    }
    
    @objc func dismissPopup(tapGestureRecognizer: UITapGestureRecognizer) {
        hideAlert()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


//MARK: - CustomHeaderViewDelegate
extension ViewProfileViewController: CustomHeaderViewDelegate {
    
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func checkmarkButtonPressed() {
        
        if newName != nil || newEmail != nil || newProfilePicture != nil {
            var isFormCorrect = true
            
            if newName != nil && newName!.count < 3 {
                nameInputView.displayWarning()
                isFormCorrect = false
            }
            
            if newEmail != nil && newEmail!.count < 5 {
                emailInputView.displayWarning()
                isFormCorrect = false
            }
            
            
            if isFormCorrect {
                
                if newName != nil && newName != userName {
                    viewModel.updateUserName(to: newName!)
                }
                
                if newEmail != nil && newEmail != userEmail && viewModel.isValidEmailAddress(email: newEmail!) {
                    viewModel.updateUserEmail(to: newEmail!)
                }
                
                if let newProfilePicture = newProfilePicture {
                    let data = newProfilePicture.pngData()
                    viewModel.updateUserPicture(to: data)
                }
                
                popupView.reArrangePopupView(toState: .confirmAlert)
                stopEditingProfileUI()
                displayAlert()
            }
        } else {
            cancelButtonPressed()
        }
    }
    
    func cancelButtonPressed() {
        nameInputView.textField.text = userName
        emailInputView.textField.text = userEmail
        setupUserProfilePicture(image: existingProfilePicture)
        customHeader.updateHeaderAppearanceType(to: .backOnlyAppearance)
        stopEditingProfileUI()
    }
}

//MARK: - FormInputViewDelegate
extension ViewProfileViewController: FormInputViewDelegate {
    
    func textFieldDidChange(textField: FormInputView, textFieldId: String, currentText: String?) {
        if currentText!.count > 0 {
            textField.hideWarning()
        }
        if textFieldId == "name" {
            newName = currentText
        } else {
            newEmail = currentText
        }
    }
}


//MARK: - ActionPopupViewDelegate
extension ViewProfileViewController: ActionPopupViewDelegate {
    
    func cameraButtonPressed() {
        let cameraImagePicker = self.displayImagePicker(sourceType: .camera)
        cameraImagePicker.delegate = self
        self.present(cameraImagePicker, animated: true)
        hideAlert()
    }
    
    func galleryButtonPressed() {
        let libraryImagePicker = self.displayImagePicker(sourceType: .photoLibrary)
        libraryImagePicker.delegate = self
        self.present(libraryImagePicker, animated: true)
        hideAlert()
    }
    
    func okButtonPressed() {
        hideAlert()
        customHeader.updateHeaderAppearanceType(to: .backOnlyAppearance)
    }
}


//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        userPicture.image = image
        newProfilePicture = image
        self.dismiss(animated: true, completion: nil)
    }
}
