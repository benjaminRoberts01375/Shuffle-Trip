// Apr 8, 2023
// Ben Roberts

import SwiftUI

final class ConfirmShuffleButtonsVM: ObservableObject {
    /// Tracks the current status of editing a trip
    @ObservedObject var editingTracker: EditingTrackerM
    /// Locations of each trip
    @Published var tripLocations: TripLocations
    /// Current buttons to show
    @Binding var buttonState: SelectedTripButtonsV.DisplayButtons
    
    /// Initializer for ConfirmShuffleButtons's view model
    /// - Parameters:
    ///   - tripLocations: Locations of all the trips
    ///   - buttonState: State of the buttons as a binding, passed in by a parent view
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>, editingTracker: EditingTrackerM) {
        self.tripLocations = tripLocations
        self.editingTracker = editingTracker
        self._buttonState = buttonState
    }
}
