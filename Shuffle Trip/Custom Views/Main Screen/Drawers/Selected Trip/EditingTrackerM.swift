// Apr 15, 2023
// Ben Roberts

import SwiftUI

final class EditingTrackerM: ObservableObject {
    @Published var isEditingTrip: Bool
    
    init() {
        self.isEditingTrip = false
    }
}
