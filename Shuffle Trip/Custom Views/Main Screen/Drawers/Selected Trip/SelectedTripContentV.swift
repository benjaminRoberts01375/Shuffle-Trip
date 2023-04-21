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
                Color.clear
                    .frame(width: 0, height: 10)
                if controller.editingTracker.isEditingTrip {
                    SearchBar(text: $controller.searchTracker.searchText, placeholder: "Find an activity...")
                }
                if !controller.searchTracker.searchText.isEmpty {
                    SearchV(searchTracker: controller.searchTracker, filter: true)
                }
                else {
                    if controller.editingTracker.isEditingTrip {
                        TripConfiguratorV(tripLocations: controller.tripLocations)
                            .padding(3)
                            .background(BlurView(style: .systemThinMaterial, opacity: 0))
                            .cornerRadius(7)
                            .shadow(color: .secondary.opacity(0.3), radius: 2)
                            .padding(.horizontal, 4)
                        
                        AddActivityButtonV(tripLocations: controller.tripLocations, activity: nil)
                            .shadow(color: .secondary.opacity(0.3), radius: 2)
                            .padding(6)
                            .padding(.horizontal, 4)
                    }
                    
                    ForEach(controller.tripLocations.getSelectedTrip()?.activityLocations ?? [], id: \.id) { activity in
                        if activity.businesses != nil {
                            ActivityPaneV(activity: activity, tripLocations: controller.tripLocations)
                                .padding(6)
                                .background(BlurView(style: .systemThinMaterial, opacity: 0))
                                .cornerRadius(7)
                                .shadow(color: .secondary.opacity(0.3), radius: 2)
                                .padding(.horizontal, 4)
                        }
                        else {
                            UngeneratedActivityPanelV(tripLocations: controller.tripLocations, activity: activity, editingTracker: controller.editingTracker)
                                .padding(6)
                                .background(BlurView(style: .systemThinMaterial, opacity: 0))
                                .cornerRadius(7)
                                .shadow(color: .secondary.opacity(0.3), radius: 2)
                                .padding(.horizontal, 4)
                        }
                        
                        if controller.editingTracker.isEditingTrip {
                            AddActivityButtonV(tripLocations: controller.tripLocations, activity: activity)
                                .padding(6)
                        }
                    }
                    Color.clear
                        .frame(width: 0, height: 10)
                }
            }
            .onReceive(controller.tripLocations.objectWillChange) { _ in
                controller.showSettings = true
                self.controller.objectWillChange.send()
            }
            .onReceive(controller.editingTracker.objectWillChange) { _ in
                controller.checkState()
            }
            .onReceive(controller.searchTracker.$searchText) { _ in
                controller.checkState()
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
