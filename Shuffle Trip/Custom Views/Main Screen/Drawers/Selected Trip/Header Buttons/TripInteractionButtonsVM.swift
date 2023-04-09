// April 7, 2023
// Ben Roberts

import SwiftUI

final class TripInteractionButtonsVM: ObservableObject {
    /// Prevents the drawer from being closed
    @Published var disableCloseButton: Bool
    /// Locations of each trip
    @Published var tripLocations: TripLocations
    /// Current buttons to show
    @Binding var buttonState: SelectedTripButtonsV.DisplayButtons
    
    /// Initializer for ConfirmShuffleButtons's view model
    /// - Parameters:
    ///   - tripLocations: Locations of all the trips
    ///   - buttonState: State of the buttons as a binding, passed in by a parent view
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>) {
        self.disableCloseButton = false
        self.tripLocations = tripLocations
        self._buttonState = buttonState
    }
}
