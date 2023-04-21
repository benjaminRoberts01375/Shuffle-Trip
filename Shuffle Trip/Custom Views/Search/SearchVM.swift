// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class SearchVM: ObservableObject {
    /// Keep track of what is being searched for
    @Published var searchTracker: LocationSearchTrackerM
    /// Keeps track if the results should be filtered to be Yelp compatable
    let filterEnabled: Bool
    
    init(searchTracker: LocationSearchTrackerM, filter: Bool) {
        self.searchTracker = searchTracker
        self.filterEnabled = filter
    }
    
    /// Wrapper for the search tracker's search location function
    /// - Parameter location: Location to look for
    internal func search(_ location: String) {
        searchTracker.searchLocation(location)
        self.objectWillChange.send()
    }
}
