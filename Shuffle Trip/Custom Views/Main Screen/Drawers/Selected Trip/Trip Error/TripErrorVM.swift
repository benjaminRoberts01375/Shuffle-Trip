// Mar 18, 2023
// Ben Roberts

import SwiftUI

@MainActor class TripErrorVM: ObservableObject {
    /// All available trip locations for the user
    @ObservedObject var tripLocations: TripLocations
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
    }
    
    /// Handles deleting the failed trip
    internal func deleteTrip() {
        for trip in tripLocations.tripLocations where trip.isSelected {
            tripLocations.RemoveTrip(trip: trip)
            return
        }
    }
    
    /// Handles reshuffling the current trip
    internal func reshuffleTrip() {
        for trip in tripLocations.tripLocations where trip.isSelected {
            trip.ShuffleTrip()
            return
        }
    }
}
