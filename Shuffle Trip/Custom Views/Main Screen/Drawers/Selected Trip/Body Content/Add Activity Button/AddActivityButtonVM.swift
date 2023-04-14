// Apr 14, 2023
// Ben Roberts

import SwiftUI

final class AddActivityButtomVM: ObservableObject {
    let index: Int
    let tripLocations: TripLocations
    @Published var termSelectorEnabled: Bool
    
    init(tripLocations: TripLocations, index: Int) {
        self.tripLocations = tripLocations
        self.index = index
        self.termSelectorEnabled = false
    }
    
    /// Adds an activity to trip locations based on the index of the button
    internal func addActivity() {
        tripLocations.getSelectedTrip()!.activityLocations.insert(Activity(), at: index)
    }
}
