// Mar 18, 2023
// Ben Roberts

import SwiftUI

@MainActor class TripErrorVM: ObservableObject {
    @ObservedObject var tripLocations: TripLocations
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
    }
    
    internal func deleteTrip() {
        for trip in tripLocations.tripLocations where trip.isSelected {
            tripLocations.RemoveTrip(trip: trip)
            return
        }
    }
    
    internal func reshuffleTrip() {
        for trip in tripLocations.tripLocations where trip.isSelected {
            trip.ShuffleTrip()
            return
        }
    }
}
