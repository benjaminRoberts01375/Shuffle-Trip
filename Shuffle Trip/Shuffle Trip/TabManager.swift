// Jan 8, 2023
// Ben Roberts

import SwiftUI

struct TabManager: View {
    @State public var needsSignIn = true
    
    var body: some View {
        
        TabView {
            Home()
                .tabItem{
                    Image(systemName: "books.vertical")
                    Text("Browse")
                }
            
            RegionSelector(region: MapDetails.region1)
                .tabItem {
                    Image(systemName: "map")
                    Text("Create Trip")
                }
            RegionSelector(region: MapDetails.region2)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .fullScreenCover(isPresented: $needsSignIn, content: {
            Text("Test")
            Button("Sign in", action: {
                needsSignIn = false
            })
        })
    }
}

struct TabManager_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
    }
}
