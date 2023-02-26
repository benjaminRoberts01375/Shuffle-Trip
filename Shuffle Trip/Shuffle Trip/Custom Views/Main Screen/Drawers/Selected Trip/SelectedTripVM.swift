// Feb 17, 2023
// Ben Roberts

import SwiftUI

@MainActor class SelectedTripVM: ObservableObject {
    @ObservedObject var tripLocations: TripLocations
    @Published var selectedTrip: TripLocation?
    @Published var selectedItem: TripLocation.Activities?
    @Published var isExpanded = false
    @Published var tripName: String = ""
    @Published var isEditingTrip: Bool = false
    @Published var shuffleConfirmation: Bool = false
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
        
        tripLocations.AddTripUpdateAction {
            for trip in tripLocations.tripLocations where trip.isSelected {
                self.selectedTrip = trip
                self.isEditingTrip = false
                self.shuffleConfirmation = false
            }
        }
    }
}
