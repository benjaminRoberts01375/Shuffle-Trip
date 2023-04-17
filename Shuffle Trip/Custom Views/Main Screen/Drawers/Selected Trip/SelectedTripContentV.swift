// Apr 12, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripContentV: View {
    @StateObject var controller: SelectedTripContentVM

    /// The initializer for the selected trip content manager
    /// - Parameter tripLocations: Locations of each trip
    init(tripLocations: TripLocations, editingTracker: EditingTrackerM) {
        self._controller = StateObject(wrappedValue: SelectedTripContentVM(tripLocations: tripLocations, editingTracker: editingTracker))
    }
    
    var body: some View {
        if controller.tripLocations.getSelectedTrip() != nil {
            VStack {
                if controller.editingTracker.isEditingTrip {
                    TripConfiguratorV(tripLocations: controller.tripLocations)
                        .padding(3)
                        .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.5))
                        .cornerRadius(7)
                        .padding(.top)
                    
                    AddActivityButtonV(tripLocations: controller.tripLocations, index: 0)
                        .padding(.vertical)
                        .shadow(color: .black.opacity(0.1), radius: 20)
                }

                ForEach(controller.tripLocations.getSelectedTrip()?.activityLocations.indices ?? 1..<2, id: \.self) { index in
                    if controller.tripLocations.getSelectedTrip()?.activityLocations[index].businesses != nil {
                        ActivityPaneV(activity: controller.tripLocations.getSelectedTrip()?.activityLocations[index] ?? Activity(), index: index + 1)
                            .padding(6)
                            .background(BlurView(style: .systemUltraThinMaterial, opacity: 0))
                            .cornerRadius(7)
                            .shadow(color: .black.opacity(0.1), radius: 20)
                    }
                    else {
                        UngeneratedActivityPanelV(activity: controller.tripLocations.getSelectedTrip()?.activityLocations[index] ?? Activity(), editingTracker: controller.editingTracker)
                            .padding(6)
                            .background(BlurView(style: .systemUltraThinMaterial, opacity: 0))
                            .cornerRadius(7)
                            .shadow(color: .black.opacity(0.1), radius: 20)
                    }
                    if controller.editingTracker.isEditingTrip {
                        AddActivityButtonV(tripLocations: controller.tripLocations, index: index + 1)
                            .padding(.vertical)
                            .shadow(color: .black.opacity(0.1), radius: 20)
                    }
                }
            }
            .onReceive(controller.tripLocations.objectWillChange) { _ in
                controller.showSettings = true
            }
            .onReceive(controller.editingTracker.objectWillChange) { _ in
                controller.checkEditing()
            }
        }
        else {
            Text("No selected trip.")
        }
    }
}

struct SelectedTripContent_Previews: PreviewProvider {
    static var previews: some View {
        SelectedTripContentV(tripLocations: TripLocations(), editingTracker: EditingTrackerM())
    }
}
