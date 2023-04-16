// Feb 17, 2023
// Ben Roberts

import SwiftUI

@MainActor class SelectedTripVM: ObservableObject {
    /// Current trip locations for the user
    @ObservedObject var tripLocations: TripLocations
    /// Keeps track of the current editing status
    @ObservedObject var editingTracker: EditingTrackerM
    /// Determines the current phase of the drawer based on the selected trips
    @Published var displayPhase: DisplayPhase
    /// Helps prevent having to unwrap over and over
    @Published var selectedTrip: TripLocation!
    /// Prevent the user from closing the drawer via the drawer
    @Published var disableCloseButton: Bool
    
    enum DisplayPhase {
        case info
        case loading
        case error
    }
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
        self.editingTracker = EditingTrackerM()
        self.displayPhase = .info
        self.disableCloseButton = false
    }
    
    /// Sets the cache for the selected trip based on what trip is found to be selected in TripLocations
    private func setSelectedTrip() {
        selectedTrip = tripLocations.tripLocations.first(where: { $0.isSelected }) ?? selectedTrip
    }
    
    /// Determines how a given trip is configured, and sets the display phase
    internal func setDisplayPhase() {
        setSelectedTrip()                           // Get the current trip
        guard selectedTrip != nil else { return }   // If there's no current trip, return
        switch selectedTrip.status {                // Use the status of the trip to determine what to display
        case .successful, .unknown:                     // If good or unknown...
            displayPhase = .info                            // Show general information
        case .error:                                    // If we errored...
            displayPhase = .error                           // Then display a generic error
        case .generating:                               // If we're generating
            displayPhase = .loading                         // Display a loading message
        }
    }
}
