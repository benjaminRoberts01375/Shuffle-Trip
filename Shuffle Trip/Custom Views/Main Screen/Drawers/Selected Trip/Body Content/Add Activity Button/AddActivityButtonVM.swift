// Apr 14, 2023
// Ben Roberts

import SwiftUI

final class AddActivityButtomVM: ObservableObject {
    /// Index of the activity within a trip
    @Published var index: Int
    /// All available trip locations for the user
    let tripLocations: TripLocations
    /// Activity this button comes after
    var activity: Activity?
    /// Determines when to show the tag selector
    @Published var tagSelectorEnabled: Bool
    
    init(tripLocations: TripLocations, activity: Activity?) {
        self.tripLocations = tripLocations
        self.activity = activity
        self.index = 0
        self.tagSelectorEnabled = false
    }
    
    /// Adds an activity to trip locations based on the index of the button
    internal func addActivity() {
        guard let selectedTrip = tripLocations.getSelectedTrip() else { return }
        selectedTrip.insertActivity(activity: Activity(), at: index)
    }
    
    internal func calculateIndex() {
        guard let activity = activity,
              let index = tripLocations.locateActivityTrip(activity: activity)?.activityLocations.firstIndex(of: activity)
        else {
            self.index = 0
            return
        }
        self.index = index
    }
}
