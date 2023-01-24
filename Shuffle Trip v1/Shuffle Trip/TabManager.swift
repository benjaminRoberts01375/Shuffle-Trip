// Jan 8, 2023
// Ben Roberts

import SwiftUI

struct TabManager: View {
    @Environment(\.colorScheme) var colorScheme
    @State public var needsSignIn = true
    
    var body: some View {
        
        TabView {
            Home()
                .tabItem{
                    Image(systemName: "books.vertical")
                    Text("Browse")
                }
            TripPlanner()
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
        .tint(.blue)
        .onAppear{
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = .systemBackground.withAlphaComponent(0.1)
            UITabBar.appearance().standardAppearance = appearance // Use this appearance when scrolling behind the TabView:
            UITabBar.appearance().scrollEdgeAppearance = appearance // Use this appearance when scrolled all the way up:
        }

    }
}
//        .fullScreenCover(isPresented: $needsSignIn, content: { // Show sign-in page
//            Login(needsSignIn: $needsSignIn)
//        })
//    }
//}

struct TabManager_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
    }
}
