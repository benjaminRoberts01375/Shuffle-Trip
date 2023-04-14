// Apr 13, 2023
// Ben Roberts

import SwiftUI

final class SelectedTripContentVM: ObservableObject {
    var tripLocations: TripLocations
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
    }
    
    enum ContentType {
        /// Display information about the trip
        case info
        /// Display the trip configurator
        case settings
    }
}
