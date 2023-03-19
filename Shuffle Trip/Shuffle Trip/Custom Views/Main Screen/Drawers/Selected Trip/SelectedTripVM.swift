// Feb 17, 2023
// Ben Roberts

import SwiftUI

@MainActor class SelectedTripVM: ObservableObject {
    @ObservedObject var tripLocations: TripLocations
    @Published var displayPhase: DisplayPhase = .info
    
    @Published var selectedTrip: TripLocation?
    @Published var shuffleConfirmation: Bool = false
    
    enum DisplayPhase {
        case info
        case loading
        case error
    }
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
    }
    
    internal func setSelectedTrip() {
        for trip in tripLocations.tripLocations where trip.isSelected {
            selectedTrip = trip
            shuffleConfirmation = false
            return
        }
    }
    
    internal func setDisplayPhase() {
        setSelectedTrip()
        if selectedTrip != nil {
            switch selectedTrip?.status {
            case .successful:
                displayPhase = .info
            case .error:
                displayPhase = .error
            case .generating:
                displayPhase = .loading
            default:
                displayPhase = .info
            }
        }
    }
}
