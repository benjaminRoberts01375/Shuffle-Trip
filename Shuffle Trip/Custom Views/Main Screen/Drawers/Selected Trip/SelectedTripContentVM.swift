// Apr 13, 2023
// Ben Roberts

import SwiftUI

final class SelectedTripContentVM: ObservableObject {
    /// All available trip locations for the user
    @ObservedObject var tripLocations: TripLocations
    /// Keeps track of the current editing status for the user
    @ObservedObject var editingTracker: EditingTrackerM
    /// Keeps track of when to show the available settings for the trip
    @Published var showSettings: Bool
    
    init(tripLocations: TripLocations, editingTracker: EditingTrackerM) {
        self.tripLocations = tripLocations
        self.editingTracker = editingTracker
        self.showSettings = false
    }
    
    // Check editing status
    internal func checkEditing() {
        self.objectWillChange.send()
    }
}
