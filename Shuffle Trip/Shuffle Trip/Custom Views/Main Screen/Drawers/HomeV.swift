// Feb 15, 2023
// Ben Roberts

import SwiftUI

struct Home: View {
    @StateObject var controller: HomeVM
    
    var body: some View {
        HStack {
            SearchBar(drawerController: controller.drawerController)
            Button(
                action: {
                    controller.TripButton()
                },
                label: {
                    Image(systemName: "scope")
                        .font(Font.title2.weight(.regular))
                        .cornerRadius(5)
                }
            )
            Spacer()
        }
    }
}
