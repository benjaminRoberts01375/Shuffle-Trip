// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class TripSearchVM: ObservableObject {
    /// Keep track of what is being searched for
    var searchTracker: LocationSearchTrackerM
    /// A list of placemarks that have been geocoded
    var results: [MKMapItem]
    
    init(searchTracker: LocationSearchTrackerM) {
        self.searchTracker = searchTracker
        self.results = []
    }
}
