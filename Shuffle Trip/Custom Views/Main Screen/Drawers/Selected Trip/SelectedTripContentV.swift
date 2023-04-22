// Apr 12, 2023
// Ben Roberts

import MapKit
import SwiftUI

struct SelectedTripContentV: View {
    @StateObject var controller: SelectedTripContentVM
    @Environment(\.dismiss) var dismiss

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
                    SearchV(searchTracker: controller.searchTracker, filter: true, selectionAction: { tripItem in
                        controller.addActivity(activity: tripItem)
                        dismiss()
                    })
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
                    if !controller.editingTracker.isEditingTrip {
                        BigButtonListTripActions(
                            openAllMapsAction: { print("NAV ALL") },
                            saveTripAction: { print("Save Trip") },
                            finishTripAction: { print("Finish Trip") }
                        )  // Large buttons for almost any activity
                        .padding(6)
                        .padding(.vertical, 3)
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

struct BigButton: View {
    var action: () -> Void
    var image: Image
    var label: String
    var highlighted: Bool
    @Binding var enabled: Bool
    
    var body: some View {
        Spacer()
            .overlay(
                Button(action: {
                    action()
                }, label: {
                    VStack {
                        image
                            .font(.title3)
                        Text(label)
                            .font(.caption2)
                    }
                    .frame(minWidth: 80, maxWidth: .infinity, minHeight: 55, maxHeight: 55)
                    .foregroundColor(highlighted ? .white : .blue)
                    .background(highlighted ? .blue : Color(UIColor.quaternarySystemFill))
                    .cornerRadius(10)
                })
            )
            .frame(height: 55)
    }
}

/// A list of large buttons for each Trip
struct BigButtonListTripActions: View {
    var openAllMapsAction: () -> Void
    var saveTripAction: () -> Void
    var finishTripAction: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Spacer()
            BigButton(                                  // Navigate button
                action: openAllMapsAction,
                image: Image(systemName: "map.fill"),
                label: "Navigate All",
                highlighted: true,
                enabled: .constant(true)
            )
            Spacer()
            BigButton(                                  // Shuffle activity button
                action: saveTripAction,
                image: Image(systemName: "square.and.arrow.down.fill"),
                label: "Save Trip",
                highlighted: false,
                enabled: .constant(true)
            )
            Spacer()
            BigButton(
                action: finishTripAction,
                image: Image(systemName: "flag.checkered.2.crossed"),
                label: "Finish Trip",
                highlighted: false,
                enabled: .constant(true)
            )
            Spacer()
            Spacer()
        }
    }
}
