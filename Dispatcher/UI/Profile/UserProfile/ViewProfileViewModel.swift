import Foundation

class ViewProfileViewModel: AuthViewModel {
    
    let vpRepository = ViewProfileRepository()
    
    
    func getUserDetails(completionHandler: @escaping (String?,String?,String?) -> ()) {
        vpRepository.getUserDetails() { userName, userEmail, userImage in
            completionHandler(userName,userEmail,userImage)
        }
    }
    
    
    func getUserUID() -> String? {
        return vpRepository.getUserUID()
    }
    
    
    func updateUserDetail(detailType: String, data: String) {
        return vpRepository.updateUserDetail(detailType: detailType, data: data)
    }
}
