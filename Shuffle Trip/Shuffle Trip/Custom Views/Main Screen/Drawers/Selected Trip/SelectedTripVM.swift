// Feb 17, 2023
// Ben Roberts

import SwiftUI

@MainActor class SelectedTripVM: ObservableObject {
    @ObservedObject var tripLocations: TripLocations
    @Published var displayPhase: DisplayPhase
    @Published var selectedTrip: TripLocation!
    @Published var shuffleConfirmation: DisplayButtons
    @Published var disableCloseButton: Bool
    
    enum DisplayPhase {
        case info
        case loading
        case error
    }
    
    enum DisplayButtons {
        case confirmShuffle
        case normal
    }
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
        self.shuffleConfirmation = .normal
        self.displayPhase = .info
        self.disableCloseButton = false
        print("reset from init")
    }
    
    internal func setSelectedTrip() {
        for trip in tripLocations.tripLocations where trip.isSelected {
            selectedTrip = trip
            shuffleConfirmation = .normal
            print("reset from set selected trip")
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
