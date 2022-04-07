import Foundation

class AuthViewModel {
    
    let repository = AuthRepository()
    
    func checkIfLoggedIn() -> userType {
       return repository.checkIfLoggedIn()
    }
    
    func isValidEmailAddress(email: String) -> Bool {
        
        return repository.isValidEmailAddress(email: email)
    }
    
    func isStrongPassword(password: String) -> Bool {
        
        var isStrongPassword = true
        //Minimum 8 characters - at least 1 Uppercase, 1 Lowercase, 1 Number, 1 Special Character
        let strongPasswoedRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        do {
            let regex = try NSRegularExpression(pattern: strongPasswoedRegex)
            let nsString = password as NSString
            let results = regex.matches(in: password, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                isStrongPassword = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            isStrongPassword = false
        }
        
        return  isStrongPassword
    }
    
    func validateSignUpFields(email: String?, password: String?, passwordAgain: String?, completionHandler: @escaping (String?, Bool) -> ()) {
        
        if let safeEmail = email, let safePassword = password, let safeAnotherPassword = passwordAgain {
            if safeAnotherPassword != safePassword {
                completionHandler("Two passwords don't match", false)
            } else if !isValidEmailAddress(email: safeEmail) {
                completionHandler("Email adress is not valid", false)
            } else if !isStrongPassword(password: safeAnotherPassword) {
                completionHandler("Password is not strong enough", false)
            } else {
                completionHandler(nil, true)
            }
        } else {
            completionHandler("One of more of the fields wasn't filled", false)
        }
    }
    
    func signUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        repository.signUserToApp(email: cleanEmail, password: cleanPassword) { error in
            completionHandler(error)
        }
    }

    func logUserToApp(email: String, password: String, completionHandler: @escaping (String?) -> ()) {
        
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        repository.logUserToApp(email: cleanEmail, password: cleanPassword) { error in
            completionHandler(error)
        }
    }
    
    func fetchUserDetails(completionHandler: @escaping (String?, String?, NSData?) -> ()) {
        repository.fetchUserDetails() { name, email, picture in
            completionHandler(name, email, picture)
        }
    }
    
    func updateUserEmail(to email: String) {
        repository.updateUserEmail(to: email)
    }
    
    func updateUserName(to name: String) {
        repository.updateUserName(to: name)
    }
    
    func updateUserPicture(to picture: Data?) {
        repository.updateUserPicture(to: picture)
    }
}
