// Jan 24, 2023
// Ben Roberts

import MapKit
import SwiftUI

// View for the main screen
struct ContentView: View {
    @StateObject var controller: ContentViewModel = ContentViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let cardSnapPositions: [CGFloat] = [controller.drawerMinimumHeight, 1 / 2, 0.97]
            ZStack {                                                                                // Main View
                RegionSelector(                                                                     // Map
                    logoPosition: controller.drawerMinimumHeight - geometry.safeAreaInsets.bottom,
                    region: controller.region,
                    tripLocations: controller.tripLocations
                )
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
                
                VStack(alignment: .trailing) {                                                      // Top blur
                    Color.clear
                        .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.0))
                        .frame(height: geometry.safeAreaInsets.top)
                    Spacer()
                }
                .zIndex(2)
                .edgesIgnoringSafeArea(.all)
                
                switch controller.interactionPhase {
                case .start:
                    BottomDrawer(                                                                   // Home drawer
                        content: HomeDV(tripLocations: controller.tripLocations, region: controller.region),
                        snapPoints: cardSnapPositions
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(100)
                case .selectedTrip:
                    BottomDrawer(                                                                   // Selected trip drawer
                        content: SelectedTripDV(tripLocations: controller.tripLocations),
                        snapPoints: cardSnapPositions
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(200)
                }
            }
            .onReceive(controller.tripLocations.objectWillChange) { _ in
                controller.updateInteractionPhase()
            }
            .fullScreenCover(isPresented: $controller.loginScreenConver) {
                LoginScreenV()
            }
            .onReceive(UserLoginM.shared.objectWillChange) { _ in
                controller.generateFriends()
            }
            .onReceive(FriendTripProfiles.shared.objectWillChange) { _ in
                print("Generated friend locations")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
