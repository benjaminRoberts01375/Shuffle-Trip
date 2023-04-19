// Feb 15, 2023
// Ben Roberts

import Combine
import MapKit
import SwiftUI

class ContentViewModel: ObservableObject {
    /// All trip locations
    @Published var tripLocations: TripLocations
    /// Trips that friends have gone on
    @Published var friendTripLocations: FriendTripProfiles
    /// Location to show on the map
    @Published var region: RegionDetails
    /// Current state of the application
    @Published var interactionPhase: InteractionPhase
    /// Shortest allowed height of the drawer
    public let drawerMinimumHeight: CGFloat
    /// For dealing with observers
    private var cancellables = Set<AnyCancellable>()
    /// Login screen shown or not
    @Published var loginScreenConver: Bool
    
    /// Datatype of the current state of the program
    enum InteractionPhase {
        case start
        case selectedTrip
    }
    
    init() {
        self.tripLocations = TripLocations()
        self.friendTripLocations = FriendTripProfiles()
        self.region = RegionDetails()
        self.drawerMinimumHeight = 100
        self.interactionPhase = InteractionPhase.start
        self.loginScreenConver = true
    }
    
    /// Handles determining the current state of the program
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
