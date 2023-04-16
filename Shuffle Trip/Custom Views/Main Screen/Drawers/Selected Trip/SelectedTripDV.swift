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
                        SelectedTripButtonsV(tripLocations: controller.tripLocations, editingTracker: controller.editingTracker)
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
            if controller.selectedTrip != nil {     // If there's a selected trip...
                switch controller.displayPhase {
                case .info:
                    VStack {
                        SelectedTripContentV(tripLocations: controller.tripLocations)
                    }
                    .transition(.slide)
                default:
                    EmptyView()
                        .transition(.opacity)
                }
            }
            else {                                                                      // Otherwise
                EmptyView()                                                                 // Show nothing
            }
        }
    }
}
