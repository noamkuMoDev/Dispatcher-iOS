import Foundation


class SignupViewModel {
    
    let repository = FirebaseAuthManager()
    
    
    func isValidEmailAddress(email: String) -> Bool {
        
        var isValidEmail = true
        let emailRegex = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegex)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                isValidEmail = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            isValidEmail = false
        }
        
        return  isValidEmail
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
    
    
    func validateSignUpFields(email: String?, password: String?, passwordAgain: String?) -> Bool {
        
        if let safeEmail = email, let safePassword = password, let safeAnotherPassword = passwordAgain {
            if safeAnotherPassword == safePassword && isStrongPassword(password: safeAnotherPassword) && isValidEmailAddress(email: safeEmail) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func signUserToApp(email: String, password: String) {
        
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        repository.signUserToApp(email: cleanEmail, password: cleanPassword)
    }
}
