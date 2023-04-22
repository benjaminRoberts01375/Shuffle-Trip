// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class SearchVM: ObservableObject {
    /// Keep track of what is being searched for
    @Published var searchTracker: LocationSearchTrackerM
    /// Keeps track if the results should be filtered to be Yelp compatable
    let filterEnabled: Bool
    /// Action to take when a location is selected
    let selectionAction: (MKMapItem) -> Void
    
    init(searchTracker: LocationSearchTrackerM, filter: Bool, selectionAction: @escaping (MKMapItem) -> Void) {
        self.searchTracker = searchTracker
        self.filterEnabled = filter
        self.selectionAction = selectionAction
    }
    
    /// Wrapper for the search tracker's search location function
    /// - Parameter location: Location to look for
    internal func search(_ location: String) {
        searchTracker.searchLocation(location)
        self.objectWillChange.send()
    }
}
