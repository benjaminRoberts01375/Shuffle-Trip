// Apr 4, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripButtonsV: View {
    var tripLocations: TripLocations
    @State var shuffleButtons: DisplayButtons
    @State var disableCloseButton: Bool

    init(tripLocations: TripLocations) {
        self._disableCloseButton = State(initialValue: false)
        self._shuffleButtons = State(initialValue: .normal)
        self.tripLocations = tripLocations
    }
    
    enum DisplayButtons {
        case confirmShuffle
        case normal
    }
    
    var body: some View {
        switch shuffleButtons {
        case .confirmShuffle:
            ConfirmShuffleButtonsV(tripLocations: tripLocations, buttonState: $shuffleButtons)
        case .normal:
            TripInteractionButtonsV(tripLocations: tripLocations, buttonState: $shuffleButtons)
        }
    }
}
