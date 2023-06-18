// April 7, 2023
// Ben Roberts

import SwiftUI

final class TripInteractionButtonsVM: ObservableObject {
    /// Tracks the current status of editing a trip
    @ObservedObject var editingTracker: EditingTrackerM
    /// Prevents the drawer from being closed
    @Published var disableCloseButton: Bool
    /// Prevents the trip from being shuffled
    @Published var preventShuffle: Bool
    /// Locations of each trip
    @ObservedObject var tripLocations: TripLocations
    /// Current buttons to show
    @Binding var buttonState: SelectedTripButtonsV.DisplayButtons
    
    /// Initializer for ConfirmShuffleButtons's view model
    /// - Parameters:
    ///   - tripLocations: Locations of all the trips
    ///   - buttonState: State of the buttons as a binding, passed in by a parent view
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>, editingTracker: EditingTrackerM) {
        self.disableCloseButton = false
        self.preventShuffle = true
        self.tripLocations = tripLocations
        self._buttonState = buttonState
        self.editingTracker = editingTracker
    }
    
    /// Check the trip locations to ensure that the activities are properlly setup
    internal func checkActivities() {
        guard let selectedTrip = tripLocations.getSelectedTrip()                        // No selected trip
        else {
            preventShuffle = true
            editingTracker.isEditingTrip = true
            return
        }

        if selectedTrip.activityLocations.isEmpty {                                     // No activities within a trip
            preventShuffle = true
            editingTracker.isEditingTrip = true
            return
        }
        
        for activity in selectedTrip.activityLocations where activity.tagIDs.isEmpty {  // An activity has no tags
            preventShuffle = true
            editingTracker.isEditingTrip = true
            return
        }
        preventShuffle = false
    }
    
    /// Check editing status
    internal func checkEditing() {
        self.objectWillChange.send()
    }
    
    /// Switches betweene editing and view the current trip
    internal func toggleEditMode() {
        if preventShuffle {
            editingTracker.isEditingTrip = true
        }
        else {
            editingTracker.isEditingTrip.toggle()
        }
    }
}
