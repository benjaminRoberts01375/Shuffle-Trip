// April 18 2023
// Joseph Marchesini

import AuthenticationServices

class SignInWithAppleButtonVM: NSObject, ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if appleIdCredential.email != nil && appleIdCredential.fullName != nil {
                // Apple has autherized the use with Apple ID and password
                registerNewUser(credential: appleIdCredential)
            } else {
                // User has been already exist with Apple Identity Provider
                signInExistingUser(credential: appleIdCredential)
            }
            return
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\n -- ASAuthorizationControllerDelegate -\(#function) -- \n")
        print(error)
    }
}

extension SignInWithAppleButtonVM {
    private func registerNewUser(credential: ASAuthorizationAppleIDCredential) {
        /// API send user data
        var name = credential.fullName?.givenName ?? ""
        let mname = credential.fullName?.middleName ?? ""
        let lname = credential.fullName?.familyName ?? ""
        if mname != "" {
            name += " " + mname
        }
        if lname != "" {
            name += " " + lname
        }
        
        UserLoginM.shared.userID = credential.user
        UserLoginM.shared.name = name
        UserLoginM.shared.email = credential.email
        UserLoginM.shared.interests = []
        UserLoginM.shared.preferences = []
        Task {
            do {
                _ = try await APIHandler.request(url: .sendUserData, dataToSend: UserLoginM.shared, decodeType: UserLoginM.self)
            }
        }
    }
    
    private func signInExistingUser(credential: ASAuthorizationAppleIDCredential) {
        /// API receive user data
        UserLoginM.shared.userID = credential.user
        
        let userRequestData = UserLoginM.UserRequest(username: UserLoginM.shared.userID)
        Task {
            do {
                let userData = try await APIHandler.request(url: .getUserData, dataToSend: userRequestData, decodeType: UserLoginM.self)
                UserLoginM.shared.name = userData.name
                UserLoginM.shared.email = userData.email
                UserLoginM.shared.interests = userData.interests
                UserLoginM.shared.preferences = userData.preferences
            }
        }
    }
}
