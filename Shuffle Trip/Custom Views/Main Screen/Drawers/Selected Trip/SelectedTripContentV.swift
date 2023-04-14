// Apr 12, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripContentV: View {
    @StateObject var controller: SelectedTripContentVM

    /// The initializer for the selected trip content manager
    /// - Parameter tripLocations: Locations of each trip
    init(tripLocations: TripLocations) {
        self._controller = StateObject(wrappedValue: SelectedTripContentVM(tripLocations: tripLocations))
    }
    
    var body: some View {
        if controller.tripLocations.getSelectedTrip() != nil {
            VStack {
                AddActivityButtonV(tripLocations: controller.tripLocations, index: 0)
                    .padding(.vertical)

                ForEach(controller.tripLocations.getSelectedTrip()?.activityLocations.indices ?? 1..<2, id: \.self) { index in
                    ActivityPaneV(activity: controller.tripLocations.getSelectedTrip()?.activityLocations[index] ?? Activity(), index: index + 1)
                    AddActivityButtonV(tripLocations: controller.tripLocations, index: index + 1)
                        .padding(.vertical)
                }
            }
            .onReceive(controller.tripLocations.objectWillChange) { _ in
                controller.showSettings = true
            }
        }
        else {
            Text("No selected trip.")
        }
    }
}

struct SelectedTripContent_Previews: PreviewProvider {
    static var previews: some View {
        SelectedTripContentV(tripLocations: TripLocations())
    }
}
