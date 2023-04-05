// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

class HomeVM: ObservableObject {
    @Published var tripLocations: TripLocations
    var region: RegionDetails
    
    init(tripLocations: TripLocations, region: RegionDetails) {
        self.tripLocations = tripLocations
        self.region = region
    }
    
    /// Handles logic for the add/remove trip button that is on the bottom drawer
    public func TripButton() {
        guard let trip = tripLocations.tripLocations.first(where: { $0.isSelected }) else { tripLocations.AddTrip(trip: TripLocation(coordinate: region.region.center, categories: tripLocations.categories)); return }
        if trip.coordinate == region.region.center {
            tripLocations.RemoveTrip(trip: trip)
        }
        else {
            tripLocations.AddTrip(trip: TripLocation(coordinate: region.region.center, categories: tripLocations.categories))
        }
    }
}
