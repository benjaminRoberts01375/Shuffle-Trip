// Feb 15, 2023
// Ben Roberts

import Combine
import MapKit
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var tripLocations: TripLocations
    @Published var friendTripLocations: FriendTripProfiles
    @Published var region: RegionDetails
    @Published var interactionPhase: InteractionPhase
    @Published var categorySheet: Bool
    public let cardMinimumHeight: CGFloat
    /// For dealing with observers
    private var cancellables = Set<AnyCancellable>()
    
    enum InteractionPhase {
        case start
        case selectedTrip
    }
    
    init() {
        self.tripLocations = TripLocations()
        self.friendTripLocations = FriendTripProfiles()
        self.region = RegionDetails()
        self.cardMinimumHeight = 100
        self.interactionPhase = InteractionPhase.start
        self.categorySheet = false
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
