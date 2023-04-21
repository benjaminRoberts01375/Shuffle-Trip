// Apr 21, 2023
// Ben Roberts

import SwiftUI

final class HomeBodySwitcherVM: ObservableObject {
    /// All user locations for the current user
    var tripLocations: TripLocations
    /// Tracker for what the user is searching for
    var searchTracker: LocationSearchTrackerM
    /// Determines content to display to the user
    @Published var displayPhase: DisplayPhase
    
    init(tripLocations: TripLocations, searchTracker: LocationSearchTrackerM) {
        self.tripLocations = tripLocations
        self.searchTracker = searchTracker
        self.displayPhase = .normal
    }
    
    enum DisplayPhase {
        case normal
        case tripSearch
    }
    
    func setDisplayPhase() {
        let newPhase = searchTracker.searchText.isEmpty ? DisplayPhase.normal : DisplayPhase.tripSearch
        if displayPhase != newPhase {
            displayPhase = newPhase
        }
    }
}
