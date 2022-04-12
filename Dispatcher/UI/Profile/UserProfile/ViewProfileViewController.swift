import UIKit
import FirebaseStorage

class ViewProfileViewController: UIViewController {

    @IBOutlet weak var customHeader: CustomHeaderView!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var screenTitle: UILabel!
    
    var storage = Storage.storage().reference()
    
    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var changePictureLabel: UILabel!
    
    @IBOutlet weak var nameInputView: FormInputView!
    @IBOutlet weak var emailInputView: FormInputView!
    
    @IBOutlet weak var darkBackgroundView: UIView!
    @IBOutlet weak var popupView: ActionPopupView!
    
    
    var newProfilePicture: UIImage? = nil
    var newPictureURL: String? = nil
    var newName: String?
    var newEmail: String?
    
    var existingProfilePicture: UIImage? = nil
    var userName: String = ""
    var userEmail: String = ""
    
    
    let viewModel = ViewProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserDetails()
        initializeUIElements()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailInputView.textField.resignFirstResponder()
        nameInputView.textField.resignFirstResponder()
    }
     
    func fetchUserDetails() {
        
        viewModel.getUserDetails() { userName, userEmail, userImage in
            if let userName = userName {
                self.userName = userName
            }
            if let userEmail = userEmail {
                self.userEmail = userEmail
            }
            if let userImage = userImage {
                let task = URLSession.shared.dataTask(with: URL(string: userImage)!, completionHandler: { data, _, error in
                    if let error = error {
                        print("Failed - \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self.userPicture.image = image
                        }
                    }
                })
                task.resume()
            }
        }
    }
    
    // V
    func initializeUIElements() {
        customHeader.initView(delegate: self, apperanceType: .backOnlyAppearance)
        popupView.initView(delegate: self)
        initTextInputs()
        userPicture.layer.cornerRadius = userPicture.frame.width / 2
        userPicture.layer.masksToBounds = true
        stopEditingProfileUI()
        hideAlert()
    }
    // V
    func initTextInputs() {
        nameInputView.initView(id: Constants.TextFieldsIDs.NAME, delegate: self, labelText: "Invalid name", placeholderText: "")
        emailInputView.initView(id: Constants.TextFieldsIDs.USRE_EMAIL, delegate: self, labelText: "Invalid email", placeholderText: "")
        nameInputView.textField.text = userName
        emailInputView.textField.text = userEmail
        nameInputView.contentView.backgroundColor = .white
        emailInputView.contentView.backgroundColor = .white
    }
    
    
    // Only image that is shown to the user on screen
    func setupDisplayedProfilePicture(image: UIImage?) {
        if let image = image {
            userPicture.image = image
        }
    }
    
    // V
    @IBAction func editProfileButtonPressed(_ sender: Any) {
        customHeader.updateHeaderAppearanceType(to: .confirmCancelAppearance)
        startEditingProfileUI()
        nameInputView.displayEditMode()
        emailInputView.displayEditMode()
        defineGestureRecognizers()
    }
    
    // V
    func defineGestureRecognizers() {
        changePictureLabel.addGestureRecognizer(UITapGestureRecognizer(target: changePictureLabel, action: #selector(changePicturePressed)))
        changePictureLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(changePicturePressed(tapGestureRecognizer:)))
        changePictureLabel.addGestureRecognizer(tapGestureRecognizer1)
        
        darkBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: darkBackgroundView, action: #selector(dismissPopup)))
        darkBackgroundView.isUserInteractionEnabled = true
               let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(dismissPopup(tapGestureRecognizer:)))
        darkBackgroundView.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // V
    @objc func changePicturePressed(tapGestureRecognizer: UITapGestureRecognizer) {
        popupView.reArrangePopupView(toState: .selectPictureFrom)
        displayAlert()
    }
    
    // V
    func displayImagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
   
    // V
    func displayAlert() {
        darkBackgroundView.isHidden = false
        popupView.isHidden = false
    }
    func hideAlert() {
        darkBackgroundView.isHidden = true
        popupView.isHidden = true
    }
    // V
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
    // V
    @objc func dismissPopup(tapGestureRecognizer: UITapGestureRecognizer) {
        hideAlert()
    }
    // V
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


//MARK: - CustomHeaderViewDelegate
extension ViewProfileViewController: CustomHeaderViewDelegate {
    
    // V
    func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    // V
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
                    viewModel.updateUserDetail(detailType: Constants.UserDefaults.CURRENT_USER_NAME, data: newName!)
                }
                
                if newEmail != nil && newEmail != userEmail && viewModel.isValidEmailAddress(email: newEmail!) {
                    viewModel.updateUserDetail(detailType: Constants.TextFieldsIDs.USRE_EMAIL, data: newEmail!)
                }
                
                if let newProfilePicture = newProfilePicture {
                    uploadPictureToCloudStorage(image: newProfilePicture) { error, url in
                        if let error = error {
                            print("Error - \(error)")
                        } else {
                            self.viewModel.updateUserDetail(detailType: Constants.UserDefaults.CURRENT_USER_IMAGE, data: url!)
                        }
                    }
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
        setupDisplayedProfilePicture(image: existingProfilePicture)
        customHeader.updateHeaderAppearanceType(to: .backOnlyAppearance)
        stopEditingProfileUI()
    }
}

//MARK: - FormInputViewDelegate
extension ViewProfileViewController: FormInputViewDelegate {
    
    
    func textFieldDidChange(inputView: FormInputView, textFieldId: String, currentText: String?) {
        if currentText!.count > 0 {
            inputView.hideWarning()
        }
        if textFieldId == Constants.TextFieldsIDs.NAME {
            newName = currentText
        } else {
            newEmail = currentText
        }
    }
}

// V
//MARK: - ActionPopupViewDelegate
extension ViewProfileViewController: ActionPopupViewDelegate {
    
    // V
    func cameraButtonPressed() {
        let cameraImagePicker = self.displayImagePicker(sourceType: .camera)
        cameraImagePicker.delegate = self
        self.present(cameraImagePicker, animated: true)
        hideAlert()
    }
    
    // V
    func galleryButtonPressed() {
        let libraryImagePicker = self.displayImagePicker(sourceType: .photoLibrary)
        libraryImagePicker.delegate = self
        self.present(libraryImagePicker, animated: true)
        hideAlert()
    }
    
    // V
    func okButtonPressed() {
        hideAlert()
        customHeader.updateHeaderAppearanceType(to: .backOnlyAppearance)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ViewProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // V
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.originalImage] as! UIImage
        userPicture.image = image // display image on screen
        newProfilePicture = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadPictureToCloudStorage(image: UIImage, completionHandler: @escaping (String?,String?) -> ()) {
        
        guard let imageData = image.pngData() else {
            completionHandler("Failed getting pngData",nil)
            return
        }
        let uid = viewModel.getUserUID()
        if let uid = uid {
            storage.child("\(uid)/profileIcon.png").putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    completionHandler("Failed to uplaod image to storage",nil)
                    return
                }
                self.storage.child("\(uid)/profileIcon.png").downloadURL( completion: { url, error in
                    guard let url = url, error == nil else {
                        completionHandler("Couldn't get downloadURL",nil)
                        return
                    }
                    let urlString = url.absoluteString
                    print("Downlod URL: \(urlString)")
                    completionHandler(nil,urlString)
                })
            })
        } else {
            completionHandler("Couldn't get usernt user's uid",nil)
        }
    }
}
