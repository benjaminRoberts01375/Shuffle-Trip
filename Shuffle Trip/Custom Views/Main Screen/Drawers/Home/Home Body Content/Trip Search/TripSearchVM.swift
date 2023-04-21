// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class TripSearchVM: ObservableObject {
    /// Keep track of what is being searched for
    @Published var searchTracker: LocationSearchTrackerM
    
    init(searchTracker: LocationSearchTrackerM) {
        self.searchTracker = searchTracker
    }
    
    /// Wrapper for the search tracker's search location function
    /// - Parameter location: Location to look for
    internal func search(_ location: String) {
        searchTracker.searchLocation(location)
        self.objectWillChange.send()
    }
}
