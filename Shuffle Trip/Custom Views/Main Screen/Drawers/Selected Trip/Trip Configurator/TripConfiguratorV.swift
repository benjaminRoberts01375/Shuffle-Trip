// Apr 11, 2023
// Ben Roberts

import SwiftUI

struct TripConfiguratorV: View {
    @StateObject var controller: TripConfiguratorVM
    @State var selection: Int = 0
    @State var options = 0...10
    
    init(tripLocation: TripLocation) {
        self._controller = StateObject(wrappedValue: TripConfiguratorVM(tripLocation: tripLocation))
    }
    
    var body: some View {
        VStack {
            TextField("Name of trip", text: $controller.tripLocation.name)
            
            HStack {
                Text("Radius: \(String(format: "%g", controller.distanceSlider)) \(controller.unitLabel)")
                    .frame(minWidth: 150, alignment: .leading)
                Spacer()
                Slider(value: $controller.distanceSlider, in: controller.sliderMin...controller.sliderMax, step: 0.1, onEditingChanged: { started in
                    if !started {
                        controller.updateTripRadius()
                    }
                })
            }
        }
    }
}
