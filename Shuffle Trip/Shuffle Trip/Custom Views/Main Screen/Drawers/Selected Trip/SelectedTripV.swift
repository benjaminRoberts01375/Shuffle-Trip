// Feb 17, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripV: View {
    @StateObject var controller: SelectedTripVM
    @State private var selectedItem: TripLocation.Activities?
    @State private var isExpanded = false
    @State var tripName: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            if controller.selectedTrip != nil {
                TextField("Name of trip", text: $tripName)
                    .onAppear {
                        tripName = controller.selectedTrip!.name
                    }
                    .onSubmit {
                        controller.selectedTrip?.name = tripName
                    }
                    .font(Font.title.weight(.bold))
                ForEach(controller.selectedTrip!.activityLocations, id: \.self) { item in
                    DisclosureGroup(
                        content: {
                            Text(item.businesses[0].location.address1)
                        }, label: {
                            Text(item.businesses[0].name)
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 5)
    }
}
