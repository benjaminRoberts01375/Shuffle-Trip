// Apr 20, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class HomeHeaderVM: ObservableObject {
    /// Trip Loctions from user
    @Published var tripLocations: TripLocations
    /// The current region the user's looking at on the map
    var region: RegionDetails
    /// The user's current search
    @Binding var searchText: String
    
    init(tripLocations: TripLocations, region: RegionDetails, searchText: Binding<String>) {
        self.tripLocations = tripLocations
        self.region = region
        self._searchText = searchText
    }
    
    /// Handles logic for the add/remove trip button that is on the bottom drawer
    public func TripButton() {
        guard let trip = tripLocations.getSelectedTrip()                                    // Ensure that there is a selected trip
        else {
            tripLocations.AddTrip(trip: TripLocation(coordinate: region.region.center))    // Otherwise create a new trip at the current location...
            return                                                                              // ...and return
        }
        
        if trip.coordinate == region.region.center {                                        // If we're currently on top of a trip's center...
            tripLocations.RemoveTrip(trip: trip)                                                // Remove that trip
        }
        else {                                                                              // Otherwise...
            tripLocations.AddTrip(trip: TripLocation(coordinate: region.region.center))         // ...Create a trip at the current location
        }
    }
}
