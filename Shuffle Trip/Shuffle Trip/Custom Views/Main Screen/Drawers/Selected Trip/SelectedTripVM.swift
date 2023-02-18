// Feb 17, 2023
// Ben Roberts

import SwiftUI

@MainActor class SelectedTripVM: ObservableObject {
    @Published var tripLocations: TripLocations
    @Published var selectedTrip: TripLocation?
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
        
        tripLocations.AddTripLocationAcion {
            for trip in tripLocations.tripLocations where trip.isSelected {
                self.selectedTrip = trip
            }
        }
    }
}
