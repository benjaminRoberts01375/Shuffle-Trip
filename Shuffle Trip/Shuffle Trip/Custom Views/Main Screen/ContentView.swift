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
                    region: controller.region,
                    tripLocations: controller.tripLocations
                )
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
                
                VStack(alignment: .trailing) {                                                      // Top blur
                    Color.clear
                        .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.0))
                        .frame(height: geometry.safeAreaInsets.top)
                    Button(action: {
                        
                    }, label: {
                        ZStack {
//                            BlurView(style: .systemUltraThinMaterial, opacity: 0)
//                            Color.red
                            Image(systemName: "tag")
                                .resizable(resizingMode: .stretch)
                                .symbolRenderingMode(.hierarchical)
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.secondary)
                                .padding(8)
                                .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.5))
                                .cornerRadius(5)
                                .padding(.horizontal)
                                .shadow(color: .primary.opacity(0.1), radius: 8)
                        }
                    })
                    Spacer()
                }
                .zIndex(2)
                .edgesIgnoringSafeArea(.all)
                
                if controller.interactionPhase == .start {
                    BottomDrawer(                                                                   // Home drawer
                        content: HomeDV(tripLocations: controller.tripLocations, region: controller.region),
                        snapPoints: cardSnapPositions
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(100)
                }
                else if controller.interactionPhase == .selectedTrip {
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
