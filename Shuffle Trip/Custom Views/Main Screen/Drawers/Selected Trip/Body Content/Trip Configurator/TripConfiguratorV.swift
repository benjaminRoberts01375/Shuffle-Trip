// Apr 11, 2023
// Ben Roberts

import SwiftUI

struct TripConfiguratorV: View {
    @StateObject var controller: TripConfiguratorVM
    
    init(tripLocations: TripLocations) {
        self._controller = StateObject(wrappedValue: TripConfiguratorVM(tripLocations: tripLocations))
    }
    
    var body: some View {
        if controller.selectedTrip != nil {
            HStack {
                Text("Radius: \(String(format: "%g", controller.metersToUnit(controller.sliderValToMeters()))) \(controller.unitLabel)")
                    .frame(minWidth: 125, alignment: .leading)
                Spacer()
                Slider(value: $controller.distanceSlider, in: 0...100, step: 0.1, onEditingChanged: { started in
                    if !started {
                        controller.updateTripRadius()
                    }
                })
            }
            .onReceive(controller.tripLocations.objectWillChange) { _ in
                controller.selectedTrip = controller.tripLocations.getSelectedTrip() ?? controller.selectedTrip
            }
        }
        else {
            EmptyView()
        }
    }
}
