// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

class HomeVM: ObservableObject {
    /// All user locations for the current user
    var tripLocations: TripLocations
    /// Current position of the map
    var region: RegionDetails

    init(tripLocations: TripLocations, region: RegionDetails) {
        self.tripLocations = tripLocations
        self.region = region
    }
}
