// Mar 20, 2023
// Ben Roberts

import SwiftUI

final class ActivityPaneVM: ObservableObject {
    /// An activity to display
    @Published var activity: Activity
    /// Index of the activity within a  trip
    @Published var index: Int
    /// Trip locations for the current user
    @ObservedObject var tripLocations: TripLocations
    
    /// Init function for the Activity Pane view model
    /// - Parameters:
    ///   - activity: Activity to display
    ///   - index: Index of the activity within a trip
    init(activity: Activity, tripLocations: TripLocations) {
        self.activity = activity
        self.tripLocations = tripLocations
        self.index = 0
    }
    
    /// Determines the index of the activity within the selected trip
    public func generateIndex() {
        guard let selectedTrip = tripLocations.getSelectedTrip() else { return }
        self.index = (selectedTrip.activityLocations.firstIndex(of: activity) ?? 0) + 1
    }
}
