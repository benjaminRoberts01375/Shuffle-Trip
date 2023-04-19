// April 18 2023
// Joseph Marchesini

import AuthenticationServices

class SignInWithAppleButtonVM: NSObject, ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            case let appleIdCredential as ASAuthorizationAppleIDCredential:
                if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName {
                    // Apple has autherized the use with Apple ID and password
                    registerNewUser(credential: appleIdCredential)
                } else {
                    // User has been already exist with Apple Identity Provider
                    signInExistingUser(credential: appleIdCredential)
                }
                break
                
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
        // API Call - Pass the email, user full name, user identity provided by Apple and other details.
        UserLoginM.shared.userID = credential.user
        UserLoginM.shared.fName = credential.fullName?.givenName
        UserLoginM.shared.mName = credential.fullName?.middleName
        UserLoginM.shared.lName = credential.fullName?.familyName
        UserLoginM.shared.email = credential.email
        Task {
            do {
                let successful = try await APIHandler.request(url: .sendUserData, dataToSend: UserLoginM.shared, decodeType: UserLoginM.self)
            }
        }
    }
      
    private func signInExistingUser(credential: ASAuthorizationAppleIDCredential) {
        // API Call - Pass the user identity, authorizationCode and identity token
        UserLoginM.shared.userID = credential.user
    }
}
