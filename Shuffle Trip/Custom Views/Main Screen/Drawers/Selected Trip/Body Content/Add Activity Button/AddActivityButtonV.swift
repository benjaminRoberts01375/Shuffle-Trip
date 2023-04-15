// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct AddActivityButtonV: View {
    @StateObject var controller: AddActivityButtomVM
    init(tripLocations: TripLocations, index: Int) {
        self._controller = StateObject(wrappedValue: AddActivityButtomVM(tripLocations: tripLocations, index: index))
    }
    
    var body: some View {
        Button(action: {
            controller.addActivity()
            controller.termSelectorEnabled = true
        }, label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.multicolor)
                Text("Add Activity")
            }
            .padding(5)
            .foregroundColor(Color.primary)
            .background(.quaternary)
            .cornerRadius(10)
        })
        .sheet(isPresented: $controller.termSelectorEnabled) {
            TagNavigatorV(activity: controller.tripLocations.getSelectedTrip()?.activityLocations[controller.index] ?? Activity())
        }
    }
}

struct AddActivityButtonV_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityButtonV(tripLocations: TripLocations(), index: 0)
    }
}
