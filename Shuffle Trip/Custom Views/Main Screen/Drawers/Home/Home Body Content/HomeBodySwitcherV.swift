// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

struct HomeBodySwitcherV: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var controller: HomeBodySwitcherVM
    
    init(tripLocations: TripLocations, searchTracker: LocationSearchTrackerM) {
        self._controller = StateObject(wrappedValue: HomeBodySwitcherVM(tripLocations: tripLocations, searchTracker: searchTracker))
    }
    
    var body: some View {
        VStack {
            if controller.displayPhase == .normal {
                Color.red
                    .frame(width: 50, height: 50)
            }
            else {
                SearchV(searchTracker: controller.searchTracker, filter: false, selectionAction: { tripItem in
                    controller.addTrip(trip: tripItem)
                    dismiss()
                })
            }
        }
        .onReceive(controller.searchTracker.objectWillChange) {
            controller.setDisplayPhase()
        }
        .onAppear {
            controller.setDisplayPhase()
        }
    }
}
