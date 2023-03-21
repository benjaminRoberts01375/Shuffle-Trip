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
            if controller.selectedTrip != nil {
                switch controller.displayPhase {
                case .info:
                    Text("Info phase")
                case .loading:
                    LoadingTripDV().header
                case .error:
                    TripErrorDV(tripLocations: controller.tripLocations).header
                }
            }
            else {
                EmptyView()
            }
        }
        .onReceive(controller.tripLocations.objectWillChange) { _ in
            controller.setDisplayPhase()
        }
        .onAppear {
            controller.setDisplayPhase()
        }
    }
    
    var body: some View {
        VStack {
            if controller.selectedTrip != nil {
                switch controller.displayPhase {
                case .info:
                    VStack {
                        ForEach(controller.selectedTrip!.activityLocations, id: \.self) { activity in
                            ActivityPaneV(activity: activity)
                        }
                    }
                case .loading:
                    LoadingTripDV().body
                case .error:
                    TripErrorDV(tripLocations: controller.tripLocations).body
                }
            }
            else {
                EmptyView()
            }
        }
    }
}
