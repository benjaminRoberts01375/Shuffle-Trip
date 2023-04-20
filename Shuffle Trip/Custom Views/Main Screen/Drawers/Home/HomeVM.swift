// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

class HomeVM: ObservableObject {
    /// All user locations for the current user
    var tripLocations: TripLocations
    /// Current position of the map
    var region: RegionDetails
    /// Location the user's searching for
    @Published var searchText: String

    init(tripLocations: TripLocations, region: RegionDetails) {
        self.tripLocations = tripLocations
        self.region = region
        self.searchText = ""
    }
}
