// April 7, 2023
// Ben Roberts

import SwiftUI

final class TripInteractionButtonsVM: ObservableObject {
    /// Prevents the drawer from being closed
    @Published var disableCloseButton: Bool
    /// Prevents the trip from being shuffled
    @Published var preventShuffle: Bool
    /// Locations of each trip
    @Published var tripLocations: TripLocations
    /// Current buttons to show
    @Binding var buttonState: SelectedTripButtonsV.DisplayButtons
    /// Checks to see if we're currently editing the trip
    @Published var editMode: Bool
    
    /// Initializer for ConfirmShuffleButtons's view model
    /// - Parameters:
    ///   - tripLocations: Locations of all the trips
    ///   - buttonState: State of the buttons as a binding, passed in by a parent view
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>) {
        self.disableCloseButton = false
        self.preventShuffle = true
        self.tripLocations = tripLocations
        self._buttonState = buttonState
        self.editMode = true
    }
    
    /// Check the trip locations to ensure that the activities are properlly setup
    internal func checkActivities() {
        preventShuffle = tripLocations.getSelectedTrip()?.activityLocations.isEmpty ?? true
        if preventShuffle {
            editMode = true
            buttonState = .editTrip
            print("Set to edit mode")
        }
    }
    
    /// Switches betweene editing and view the current trip
    internal func toggleEditMode() {
        if preventShuffle {
            editMode = true
            buttonState = .editTrip
        }
        else {
            editMode.toggle()
            buttonState = editMode ? .editTrip : .normal
        }
    }
}
