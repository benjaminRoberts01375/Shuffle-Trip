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
                    HStack {
                        TextField("Name of trip", text: $controller.selectedTrip.name)
                            .font(.title2.weight(.bold))
                        Spacer()
                        SelectedTripButtonsV(tripLocations: controller.tripLocations)
                    }
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
                        ForEach(Array(controller.selectedTrip.activityLocations.enumerated()), id: \.1.self) { index, activity in
                            ActivityPaneV(activity: activity, index: index + 1)
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
