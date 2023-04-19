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
        calculateIndex()
    }
    
    /// Adds an activity to trip locations based on the index of the button
    internal func addActivity() {
        guard let selectedTrip = tripLocations.getSelectedTrip() else { return }
        selectedTrip.insertActivity(activity: Activity(), at: index)
    }
    
    /// Calculate the index for where this activity slots into with other activities
    internal func calculateIndex() {
        guard let activity = activity,                                                                                      // Ensure activity is valid
              let index = tripLocations.locateActivityTrip(activity: activity)?.activityLocations.firstIndex(of: activity)  // Determine index of activity within the trip
        else {
            self.index = 0                                                                                                  // Activity wasn't found, default to 0
            return
        }
        self.index = index + 1                                                                                              // Off by 1 to ensure that activity is placed AFTER the Add Activity button
    }
}
