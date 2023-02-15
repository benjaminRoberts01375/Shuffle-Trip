// Jan 24, 2023
// Ben Roberts

import MapKit
import SwiftUI

// View for the main screen
struct ContentView: View {
    @StateObject var userIsSearching: SearchTracker = SearchTracker()
    @StateObject var tripLocations: TripLocations = TripLocations()
    @State var region: MKCoordinateRegion = MapDetails.region1
    @State var allowNewTrip: Bool = true
    let cardMinimumHeight: CGFloat = 125
    
    var body: some View {
        GeometryReader { geometry in
            let cardSnapPositions: [CGFloat] = [cardMinimumHeight, 1 / 2, 0.97]
            ZStack {                                                                            // Main View
                RegionSelector(
                    logoPosition: cardMinimumHeight - geometry.safeAreaInsets.bottom,
                    region: $region,
                    tripLocations: tripLocations
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
                            VStack {
                                HStack {
                                    SearchBar(userIsSearching: userIsSearching)
                                    Button(
                                        action: {
                                            tripLocations.AddTrip(trip: TripLocation(coordinate: region.center))
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
