// Jan 24, 2023
// Ben Roberts

import MapKit
import SwiftUI

// View for the main screen
struct ContentView: View {
    @StateObject var controller: ContentViewModel = ContentViewModel()
    @StateObject var userIsSearching: SearchTracker = SearchTracker()
    
    var body: some View {
        GeometryReader { geometry in
            let cardSnapPositions: [CGFloat] = [controller.cardMinimumHeight, 1 / 2, 0.97]
            ZStack {                                                                            // Main View
                RegionSelector(
                    logoPosition: controller.cardMinimumHeight - geometry.safeAreaInsets.bottom,
                    region: $controller.region,
                    tripLocations: controller.tripLocations
                )                                                            // Map
                .edgesIgnoringSafeArea(.all)
                VStack {                                                                        // Top blur
                    Color.clear
                        .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.0))
                        .frame(height: geometry.safeAreaInsets.top)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                BottomDrawer(
                    controller: BottomDrawerVM(                                                 // Bottom Drawer
                        content:
                            VStack(alignment: .leading) {
                                HStack {
                                    SearchBar(userIsSearching: userIsSearching)
                                    Button(
                                        action: {
                                            controller.TripButton()
                                        },
                                        label: {
                                            Image(systemName: "scope")
                                                .font(Font.title2.weight(.regular))
                                                .cornerRadius(5)
                                                .padding(.leading, -10)
                                        }
                                    )
                                    Spacer()
                                }
                                .padding(.bottom, 20)
                                Text("Recommended Trips")
                                    .font(Font.headline.weight(.regular))
                                Text("Previous Trips")
                                    .font(Font.headline.weight(.regular))
                            },
                        snapPoints: cardSnapPositions,
                        goFull: userIsSearching
                    )
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
