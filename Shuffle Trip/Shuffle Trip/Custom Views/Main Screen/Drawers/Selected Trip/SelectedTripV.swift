// Feb 17, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripV: View {
    @StateObject var controller: SelectedTripVM
    
    enum EmptyTrip: String {
        case title = "No trip selected."
    }
    let colors: [Color] = [.red, .green, .blue]
    
    var body: some View {
        VStack {
            Text("Name: \(controller.selectedTrip?.activityLocations[0].businesses[0].name ?? EmptyTrip.title.rawValue)")
            if controller.selectedTrip != nil {
                ForEach ( controller.selectedTrip!.activityLocations, id: \.self) { activity in
                    Text(activity.businesses[0].name)
                }
            }
        }
    }
}
