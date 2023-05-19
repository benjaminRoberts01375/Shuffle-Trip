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
            ZStack(alignment: .top) {
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .accessibilityLabel("Decorative background photo")
                VStack {
                    Spacer()
                    Text("Shuffle Trip")
                        .font(.system(size: 50))
                        .fontWeight(.semibold)
                        .padding()
                        .background(BlurView(style: .systemThinMaterialLight, opacity: 0))
                        .foregroundColor(.black)
                        .cornerRadius(20)
                        .shadow(radius: 3, y: 3)
                    Spacer()
                    Spacer()
                    Spacer()
                    SignInWithAppleButton()
                        .frame(width: 200, height: 60, alignment: .center)
                        .onTapGesture(perform: showAppleLoginView)
                        .cornerRadius(50)
                        .accessibilityAddTraits(.isButton)
                        .onReceive(UserLoginM.shared.objectWillChange) { _ in
                            if UserLoginM.shared.userID != nil {
                                dismiss()
                            }
                        }
                    Spacer()
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
