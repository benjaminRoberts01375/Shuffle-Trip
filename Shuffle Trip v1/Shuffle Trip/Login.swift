// January 8, 2022
// Ben Roberts

import SwiftUI

struct Login: View {
    @Binding var needsSignIn: Bool
    
    var body: some View {
        Button(action: {
            needsSignIn = false
        }, label: {
            Text("Log in?")
        })
    }
}

//struct Login_Preview: PreviewProvider {
//    @State var loggedIn = false
//    static var previews: some View {
//        Login(validLogin: $loggedIn)
//    }
//}
