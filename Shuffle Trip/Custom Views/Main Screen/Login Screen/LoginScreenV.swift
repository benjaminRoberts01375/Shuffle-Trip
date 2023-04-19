// April 17 2023
// Joseph Marchesini

import AuthenticationServices
import SwiftUI

struct LoginScreenV: View {
    @StateObject var contoller: LoginScreenVM
    @Environment(\.dismiss) var dismiss
    var signInWithAppleButtonVM: SignInWithAppleButtonVM
    
    init() {
        self._contoller = StateObject(wrappedValue: LoginScreenVM())
        signInWithAppleButtonVM = SignInWithAppleButtonVM()
    }
    
    var body: some View {
        SignInWithAppleButton()
            .frame(width: 280, height: 60, alignment: .center)
            .onTapGesture(perform: showAppleLoginView)
            .cornerRadius(50)
            .accessibilityAddTraits(.isButton)
            .onReceive(UserLoginM.shared.objectWillChange) { _ in
                if UserLoginM.shared.userID != nil {
                    dismiss()
                }
            }
    }
    
    private func showAppleLoginView() {

        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = signInWithAppleButtonVM
        controller.performRequests()
    }
}

struct LoginScreenV_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenV()
    }
}
