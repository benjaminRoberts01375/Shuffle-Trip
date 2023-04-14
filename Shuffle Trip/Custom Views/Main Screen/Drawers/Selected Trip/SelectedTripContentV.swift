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
            
        }
        else {
            EmptyView()
        }
    }
}

struct SelectedTripContent_Previews: PreviewProvider {
    static var previews: some View {
        SelectedTripContentV(tripLocations: TripLocations())
    }
}
