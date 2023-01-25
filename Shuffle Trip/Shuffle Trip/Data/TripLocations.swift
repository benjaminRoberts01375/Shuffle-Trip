// Jan 25, 2023
// Ben Roberts

import SwiftUI
import MapKit

/**
 A class to allow for sharing TripLocation data
 */
public class TripLocations: ObservableObject {
    @Published var tripLocation: CLLocationCoordinate2D
    @Published var activityLocations: [Activities]
    
    init(tripLocation: CLLocationCoordinate2D, activityLocations: [Activities]) {
        self.tripLocation = tripLocation
        self.activityLocations = activityLocations
    }
    
    struct Activities {
        let start: DateComponents
        let end: DateComponents
        let location: CLLocationCoordinate2D
    }
}
