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
        }, label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.multicolor)
                Text("Add Activity - \(controller.index)")
            }
            .padding(5)
            .foregroundColor(Color.primary)
            .background(.quaternary)
            .cornerRadius(10)
        })
    }
}

struct AddActivityButtonV_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityButtonV(tripLocations: TripLocations(), index: 0)
    }
}
