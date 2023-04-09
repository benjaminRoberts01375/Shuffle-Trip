// Apr 7, 2023
// Ben Roberts 

import SwiftUI

struct ConfirmShuffleButtonsV: View {
    @StateObject var controller: ConfirmShuffleButtonsVM
    
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>) {
        self._controller = StateObject(wrappedValue: ConfirmShuffleButtonsVM(tripLocations: tripLocations, buttonState: buttonState))
    }
    var body: some View {
        HStack {
            Text("Confirm")
                .font(Font.headline.weight(.bold))
            Button(action: {                            // Confirm shuffle - No
                withAnimation {
                    controller.buttonState = .normal

                }
            }, label: {
                Image(systemName: "arrow.uturn.backward.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.green)
                    .font(Font.title.weight(.bold))
            })
            Button(action: {                            // Confirm shuffle - Yes
                controller.tripLocations.tripLocations.first(where: { $0.isSelected })?.ShuffleTrip()
                withAnimation {
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
