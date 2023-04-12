// Apr 11, 2023
// Ben Roberts

import SwiftUI

struct TripConfiguratorV: View {
    @StateObject var controller: TripConfiguratorVM
    
    init(tripLocation: TripLocation) {
        self._controller = StateObject(wrappedValue: TripConfiguratorVM(tripLocation: tripLocation))
    }
    
    var body: some View {
        VStack {
            TextField("Name of trip", text: $controller.tripLocation.name)
            
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
        }
    }
}
