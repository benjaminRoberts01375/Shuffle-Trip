// Apr 15, 2023
// Ben Roberts

import SwiftUI

/// Handles editing trip status for the selceted trip drawer
final class EditingTrackerM: ObservableObject {
    /// Is the current trip currently being edited?
    @Published var isEditingTrip: Bool
    
    init() {
        self.isEditingTrip = false
    }
}
