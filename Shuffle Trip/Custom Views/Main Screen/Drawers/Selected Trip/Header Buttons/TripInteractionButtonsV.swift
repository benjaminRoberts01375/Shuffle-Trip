// Apr 7, 2023
// Ben Roberts

import SwiftUI

struct TripInteractionButtonsV: View {
    @StateObject var controller: TripInteractionButtonsVM
    
    init(tripLocations: TripLocations, buttonState: Binding<SelectedTripButtonsV.DisplayButtons>) {
        self._controller = StateObject(wrappedValue: TripInteractionButtonsVM(tripLocations: tripLocations, buttonState: buttonState))
    }
    
    var body: some View {
        HStack {
            Button(action: {                            // Shuffle button
                withAnimation {
                    controller.buttonState = .confirmShuffle
                }
            }, label: {
                Image(systemName: "shuffle.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.secondary)
                    .font(Font.title.weight(.bold))
            })
            .disabled(controller.preventShuffle)
            .opacity(controller.preventShuffle ? 0.5 : 1.0)

            Button(action: {                            // Trip settings
                withAnimation {
                    controller.toggleEditMode()
                }
            }, label: {
                Image(systemName: "gear.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(controller.editMode ? Color.green : Color.secondary)
                    .font(Font.title.weight(.bold))
                    .disabled(controller.preventShuffle)
                    .opacity(controller.preventShuffle ? 0.5 : 1.0)
            })

            Button(action: {                            // Close card button
                controller.tripLocations.SelectTrip()
            }, label: {
                Image(systemName: "chevron.down.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.secondary)
                    .font(Font.title.weight(.bold))
            })
            .disabled(controller.disableCloseButton)
            .opacity(controller.disableCloseButton ? 0.5 : 1.0)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            withAnimation {
                controller.disableCloseButton = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation {
                controller.disableCloseButton = false
            }
        }
        .onReceive(controller.tripLocations.getSelectedTrip()?.objectWillChange ?? TripLocation(coordinate: MapDetails.location2).objectWillChange) { _ in
            controller.checkActivities()
        }
        .onAppear {
            controller.checkActivities()
        }
    }
}
