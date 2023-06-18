// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct AddActivityButtonV: View {
    @StateObject var controller: AddActivityButtomVM
    init(tripLocations: TripLocations, activity: Activity?) {
        self._controller = StateObject(wrappedValue: AddActivityButtomVM(tripLocations: tripLocations, activity: activity))
    }
    
    var body: some View {
        Button(action: {
            controller.addActivity()
            controller.tagSelectorEnabled = true
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
        .onReceive(controller.tripLocations.objectWillChange) { _ in
            controller.calculateIndex()
        }
        .sheet(isPresented: $controller.tagSelectorEnabled) {
            TagNavigatorV(activity: controller.tripLocations.getSelectedTrip()?.activityLocations[controller.index] ?? Activity())
        }
    }
}
