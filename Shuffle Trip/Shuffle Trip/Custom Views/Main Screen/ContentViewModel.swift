// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var homeDrawerController: DrawerController
    @Published var tripDrawerController: DrawerController
    @Published var tripLocations: TripLocations
    @Published var region: MKCoordinateRegion
    @Published var interactionPhase: InteractionPhase
    public let cardMinimumHeight: CGFloat
    
    enum InteractionPhase {
        case start
        case selectedTrip
    }
    
    init() {
        self.homeDrawerController = DrawerController()
        self.tripDrawerController = DrawerController(isFull: false, isPresented: false)
        self.tripLocations = TripLocations()
        self.region = MapDetails.region2
        self.cardMinimumHeight = 100
        self.interactionPhase = InteractionPhase.start
        
        self.tripLocations.AddTripUpdateAction {
            withAnimation {
                if self.tripLocations.tripLocations.contains(where: { $0.isSelected }) {
                    self.interactionPhase = .selectedTrip
                }
                else {
                    self.interactionPhase = .start
                }
            }
        }
    }
}
