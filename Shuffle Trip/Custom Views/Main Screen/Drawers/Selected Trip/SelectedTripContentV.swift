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
                    
                    AddActivityButtonV(tripLocations: controller.tripLocations, activity: nil)
                        .shadow(color: .black.opacity(0.1), radius: 20)
                }
                
                ForEach(controller.tripLocations.getSelectedTrip()?.activityLocations ?? [], id: \.id) { activity in
                    if activity.businesses != nil {
                        ActivityPaneV(activity: activity, tripLocations: controller.tripLocations)
                            .padding(6)
                            .background(BlurView(style: .systemUltraThinMaterial, opacity: 0))
                            .cornerRadius(7)
                            .shadow(color: .black.opacity(0.1), radius: 20)
                    }
                    else {
                        UngeneratedActivityPanelV(tripLocations: controller.tripLocations, activity: activity, editingTracker: controller.editingTracker)
                            .padding(6)
                            .background(BlurView(style: .systemUltraThinMaterial, opacity: 0))
                            .cornerRadius(7)
                            .shadow(color: .black.opacity(0.1), radius: 20)
                    }
                    
                    if controller.editingTracker.isEditingTrip {
                        AddActivityButtonV(tripLocations: controller.tripLocations, activity: activity)
                    }
                }
            }
            .onReceive(controller.tripLocations.objectWillChange) { _ in
                controller.showSettings = true
                self.controller.objectWillChange.send()
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
