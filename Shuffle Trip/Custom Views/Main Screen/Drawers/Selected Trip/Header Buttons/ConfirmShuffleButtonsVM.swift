// Apr 8, 2023
// Ben Roberts

import SwiftUI

final class ConfirmShuffleButtonsVM: ObservableObject {
    @Published var tripLocations: TripLocations
    @Binding var buttonState: SelectedTripButtonsV.DisplayButtons
    
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>) {
        self.tripLocations = tripLocations
        self._buttonState = buttonState
    }
}
