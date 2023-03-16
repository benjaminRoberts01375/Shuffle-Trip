// Feb 15, 2023
// Ben Roberts

import Combine
import MapKit
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var homeDrawerController: DrawerController
    @Published var tripDrawerController: DrawerController
    @Published var tripLocations: TripLocations
    @Published var region: RegionDetails
    @Published var interactionPhase: InteractionPhase
    public let cardMinimumHeight: CGFloat
    /// For dealing with observers
    private var cancellables = Set<AnyCancellable>()
    
    enum InteractionPhase {
        case start
        case selectedTrip
    }
    
    init() {
        self.homeDrawerController = DrawerController()
        self.tripDrawerController = DrawerController(isFull: false, isPresented: false)
        self.tripLocations = TripLocations()
        self.region = RegionDetails()
        self.cardMinimumHeight = 100
        self.interactionPhase = InteractionPhase.start
    }
    
    internal func updateInteractionPhase() {
        withAnimation {
            if tripLocations.tripLocations.contains(where: { $0.isSelected }) {
                interactionPhase = .selectedTrip
            }
            else {
                interactionPhase = .start
            }
        }
    }
}
