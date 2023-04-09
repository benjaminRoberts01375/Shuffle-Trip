// Feb 17, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripDV: DrawerView {
    @ObservedObject var controller: SelectedTripVM
    
    init(tripLocations: TripLocations) {
        self._controller = ObservedObject(wrappedValue: SelectedTripVM(tripLocations: tripLocations))
    }
    
    var header: some View {
        VStack {
            if controller.selectedTrip != nil {                                         // If there's a selected trip...
                switch controller.displayPhase {                                            // Switch between 3 different screens
                case .info:                                                                     // info screen
                    HStack {
                        TextField("Name of trip", text: $controller.selectedTrip.name)
                            .font(.title2.weight(.bold))
                        Spacer()
                        SelectedTripButtonsV(tripLocations: controller.tripLocations)
                    }
                case .loading:                                                                  // loading screen
                    LoadingTripDV().header
                case .error:                                                                    // error screen
                    TripErrorDV(tripLocations: controller.tripLocations).header
                }
            }
            else {                                                                      // Otherwise...
                EmptyView()                                                                 // Show nothing
            }
        }
        .onReceive(controller.tripLocations.objectWillChange) { _ in                    // When there's an update to the trip locations...
            controller.setDisplayPhase()                                                    // Determine which screen to show
        }
        .onAppear {                                                                     // When the view loads...
            controller.setDisplayPhase()                                                    // Determine which screen to show
        }
    }
    
    var body: some View {
        VStack {
            if controller.selectedTrip != nil && controller.displayPhase == .info {     // If there's a selected trip...
                VStack {
                    ForEach(
                        Array(controller.selectedTrip.activityLocations.enumerated()),      // Loop through each of the selected trip's activities
                        id: \.1.self
                    ) { index, activity in
                        ActivityPaneV(activity: activity, index: index + 1)                     // Show each activity in an Activity Panel view
                    }
                }
            }
            else {                                                                      // Otherwise
                EmptyView()                                                                 // Show nothing
            }
        }
    }
}
