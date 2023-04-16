// Apr 7, 2023
// Ben Roberts 

import SwiftUI

struct ConfirmShuffleButtonsV: View {
    @StateObject var controller: ConfirmShuffleButtonsVM
    
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>, editingTracker: EditingTrackerM) {
        self._controller = StateObject(wrappedValue: ConfirmShuffleButtonsVM(tripLocations: tripLocations, buttonState: buttonState, editingTracker: editingTracker))
    }
    var body: some View {
        HStack {
            Text("Confirm")
                .font(Font.headline.weight(.bold))
            Button(action: {                            // Confirm shuffle - No
                withAnimation {
                    controller.editingTracker.isEditingTrip = true
                    controller.buttonState = .normal
                }
            }, label: {
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.green)
                    .font(Font.title.weight(.bold))
            })
            Button(action: {                            // Confirm shuffle - Yes
                controller.tripLocations.getSelectedTrip()?.ShuffleTrip()
                withAnimation {
                    controller.editingTracker.isEditingTrip = false
                    controller.buttonState = .normal
                }
            }, label: {
                Image(systemName: "shuffle.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.red)
                    .font(Font.title.weight(.bold))
            })
        }
        .padding(5)
        .background(BlurView(style: .systemUltraThinMaterial, opacity: 0))
        .cornerRadius(40)
        .transition(.opacity)
    }
}
