// April 18 2023
// Joseph Marchesini

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    typealias UIViewType = ASAuthorizationAppleIDButton
  
    func makeUIView(context: Context) -> UIViewType {
        return ASAuthorizationAppleIDButton(type: .signIn, style: colorScheme == .dark ? .white : .black)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
