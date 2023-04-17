// Apr 14, 2023
// Ben Roberts

import SwiftUI

final class AddActivityButtomVM: ObservableObject {
    /// Index of the activity within a trip
    let index: Int
    /// All available trip locations for the user
    let tripLocations: TripLocations
    /// Determines when to show the tag selector
    @Published var tagSelectorEnabled: Bool
    
    init(tripLocations: TripLocations, index: Int) {
        self.tripLocations = tripLocations
        self.index = index
        self.tagSelectorEnabled = false
    }
    
    /// Adds an activity to trip locations based on the index of the button
    internal func addActivity() {
        guard let selectedTrip = tripLocations.getSelectedTrip() else { return }
        selectedTrip.insertActivity(activity: Activity(), at: index)
    }
}
