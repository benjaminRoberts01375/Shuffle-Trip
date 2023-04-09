// April 7, 2023
// Ben Roberts

import SwiftUI

final class TripInteractionButtonsVM: ObservableObject {
    @Published var disableCloseButton: Bool
    @Published var tripLocations: TripLocations
    @Binding var buttonState: SelectedTripButtonsV.DisplayButtons
    
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>) {
        self.disableCloseButton = false
        self.tripLocations = tripLocations
        self._buttonState = buttonState
    }
}
