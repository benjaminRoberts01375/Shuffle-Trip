// Apr 4, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripButtonsV: View {
    /// Locations of each trip
    var tripLocations: TripLocations
    /// Determines which buttons to show when
    @State var buttonState: DisplayButtons
    /// Disallow the user to close the current drawer
    @State var disableCloseButton: Bool
    @ObservedObject var editingTracker: EditingTrackerM
    
    /// The initializer for the selected trip button manager
    /// - Parameter tripLocations: Locations of each trip
    init(tripLocations: TripLocations, editingTracker: EditingTrackerM) {
        self._disableCloseButton = State(initialValue: false)
        self._buttonState = State(initialValue: .normal)
        self.tripLocations = tripLocations
        self.editingTracker = editingTracker
    }
    
    /// Available arrangements for button layouts
    enum DisplayButtons {
        /// Confirmation to shuffle a trip
        case confirmShuffle
        /// Buttons to show before user interaction
        case normal
    }
    
    var body: some View {
        switch buttonState {
        case .confirmShuffle:                   // If showing the confirmation to shuffle an entire trip
            ConfirmShuffleButtonsV(                 // Show the Confirm Shuffle Buttons view
                tripLocations: tripLocations,
                buttonState: $buttonState,
                editingTracker: editingTracker
            )
        case .normal:                           // If showing the normal buttons
            TripInteractionButtonsV(                // Show the buttons for potential trip interaction
                tripLocations: tripLocations,
                buttonState: $buttonState,
                editingTracker: editingTracker
            )
        }
    }
}
