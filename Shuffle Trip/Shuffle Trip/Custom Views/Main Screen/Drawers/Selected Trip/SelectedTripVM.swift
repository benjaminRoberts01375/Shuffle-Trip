// Feb 17, 2023
// Ben Roberts

import SwiftUI

@MainActor class SelectedTripVM: ObservableObject {
    @ObservedObject var tripLocations: TripLocations
    @Published var selectedTrip: TripLocation?
    @Published var shuffleConfirmation: Bool = false
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
    }
    
    internal func setSelectedTrip() {
        for trip in tripLocations.tripLocations where trip.isSelected {
            selectedTrip = trip
            shuffleConfirmation = false
            return
        }
    }
}
