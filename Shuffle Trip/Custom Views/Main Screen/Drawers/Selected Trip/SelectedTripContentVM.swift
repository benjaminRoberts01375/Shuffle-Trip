// Apr 13, 2023
// Ben Roberts

import SwiftUI

final class SelectedTripContentVM: ObservableObject {
    @ObservedObject var tripLocations: TripLocations
    @ObservedObject var editingTracker: EditingTrackerM
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
