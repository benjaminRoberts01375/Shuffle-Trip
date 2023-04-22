// Apr 13, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class SelectedTripContentVM: ObservableObject {
    /// All available trip locations for the user
    @ObservedObject var tripLocations: TripLocations
    /// Keeps track of the current editing status for the user
    @ObservedObject var editingTracker: EditingTrackerM
    /// Keeps track of when to show the available settings for the trip
    @Published var showSettings: Bool
    /// Tracking details about search in regards to location
    @ObservedObject var searchTracker: LocationSearchTrackerM
    
    init(tripLocations: TripLocations, editingTracker: EditingTrackerM) {
        self.tripLocations = tripLocations
        self.editingTracker = editingTracker
        self.showSettings = false
        self.searchTracker = LocationSearchTrackerM()
    }
    
    // Check editing status
    internal func checkState() {
        self.objectWillChange.send()
    }
    
    internal func addActivity(activity: MKMapItem) {
    }
}
