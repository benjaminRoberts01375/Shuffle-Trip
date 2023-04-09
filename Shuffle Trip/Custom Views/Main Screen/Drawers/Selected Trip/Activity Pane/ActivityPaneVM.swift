// Mar 20, 2023
// Ben Roberts

import SwiftUI

final class ActivityPaneVM: ObservableObject {
    /// An activity to display
    @Published var activity: Activity
    /// Index of the activity within a  trip
    var index: Int
    
    /// Init function for the Activity Pane view model
    /// - Parameters:
    ///   - activity: Activity to display
    ///   - index: Index of the activity within a trip
    init(activity: Activity, index: Int) {
        self.activity = activity
        self.index = index
    }
}
