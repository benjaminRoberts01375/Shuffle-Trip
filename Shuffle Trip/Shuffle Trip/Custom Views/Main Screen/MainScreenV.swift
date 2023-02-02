// Jan 24, 2023
// Ben Roberts

import SwiftUI

// View for the main screen
struct MainScreenV: View {
    @StateObject var userIsSearching: SearchTracker = SearchTracker()
    
    var body: some View {
        GeometryReader { geometry in
            let cardSnapPositions: [CGFloat] = [125, geometry.size.height/2, geometry.size.height + geometry.safeAreaInsets.bottom - 10]
            
            ZStack {                                                                                            // Main View
                RegionSelector(logoPosition: (cardSnapPositions.min() ?? 500) - geometry.safeAreaInsets.bottom) // Map
                    .edgesIgnoringSafeArea(.all)
                VStack {                                                                                        // Top blur
                    Color.clear
                        .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.0))
                        .frame(height: geometry.safeAreaInsets.top)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                BottomDrawer(controller: BottomDrawerVM (                                                       // Bottom Drawer
                    content:
                        VStack {
                            SearchBar(userIsSearching: userIsSearching)
                        },
                    snapPoints: cardSnapPositions,
                    goFull: userIsSearching
                ))
            }
        }
    }
}

struct MainScreenMV_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenV()
    }
}
