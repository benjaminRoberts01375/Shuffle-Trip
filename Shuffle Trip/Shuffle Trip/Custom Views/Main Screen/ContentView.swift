// Jan 24, 2023
// Ben Roberts

import MapKit
import SwiftUI

// View for the main screen
struct ContentView: View {
    @StateObject var controller: ContentViewModel = ContentViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let cardSnapPositions: [CGFloat] = [controller.cardMinimumHeight, 1 / 2, 0.97]
            ZStack {                                                                                // Main View
                RegionSelector(                                                                     // Map
                    logoPosition: controller.cardMinimumHeight - geometry.safeAreaInsets.bottom,
                    region: $controller.region,
                    tripLocations: controller.tripLocations
                )
                .edgesIgnoringSafeArea(.all)
                VStack {                                                                            // Top blur
                    Color.clear
                        .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.0))
                        .frame(height: geometry.safeAreaInsets.top)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                BottomDrawer(                                                                       // Home drawer
                    content: HomeV(drawerController: controller.homeDrawerController, tripLocations: controller.tripLocations, region: $controller.region),
                    snapPoints: cardSnapPositions,
                    controller: controller.homeDrawerController
                )
                BottomDrawer(                                                                       // Selected trip drawer
                    content: SelectedTripV(tripLocations: controller.tripLocations),
                    snapPoints: cardSnapPositions,
                    controller: controller.tripDrawerController
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
