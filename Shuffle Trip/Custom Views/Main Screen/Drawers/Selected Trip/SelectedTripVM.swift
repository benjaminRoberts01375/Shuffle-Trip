// Feb 17, 2023
// Ben Roberts

import SwiftUI

@MainActor class SelectedTripVM: ObservableObject {
    @ObservedObject var tripLocations: TripLocations
    @ObservedObject var editingTracker: EditingTrackerM
    @Published var displayPhase: DisplayPhase
    @Published var selectedTrip: TripLocation!
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
        setSelectedTrip()
        guard selectedTrip != nil else { return }
        switch selectedTrip.status {
        case .successful, .unknown:
            displayPhase = .info
        case .error:
            displayPhase = .error
        case .generating:
            displayPhase = .loading
        }
    }
}
