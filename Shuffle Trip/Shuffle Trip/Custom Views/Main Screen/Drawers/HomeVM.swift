// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

class HomeVM: ObservableObject {
    @Binding var userIsSearching: DrawerController
    @Binding var tripLocations: TripLocations
    @Binding var region: MKCoordinateRegion
    
    init(userIsSearching: Binding<DrawerController>, tripLocations: Binding<TripLocations>, region: Binding<MKCoordinateRegion>) {
        self._userIsSearching = userIsSearching
        self._tripLocations = tripLocations
        self._region = region
    }
    
    /// Handles logic for the add/remove trip button that is on the bottom drawer
    public func TripButton() {
        guard let trip = tripLocations.tripLocations.first(where: { $0.isSelected }) else { tripLocations.AddTrip(trip: TripLocation(coordinate: region.center)); return }
        if trip.coordinate == region.center {
            tripLocations.RemoveTrip(trip: trip)
        }
        else {
            tripLocations.AddTrip(trip: TripLocation(coordinate: region.center))
        }
    }
}
