// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

@MainActor class HomeVM: ObservableObject {
    /// All user locations for the current user
    var tripLocations: TripLocations
    /// Current position of the map
    var region: RegionDetails
    /// Tracker for what the user is searching for
    var searchTracker: LocationSearchTrackerM
    
    init(tripLocations: TripLocations, region: RegionDetails) {
        self.tripLocations = tripLocations
        self.region = region
        self.searchTracker = LocationSearchTrackerM()
    }
}
