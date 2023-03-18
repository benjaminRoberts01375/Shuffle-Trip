// Feb 17, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripDV: DrawerView {
    @StateObject var controller: SelectedTripVM
    
    init(tripLocations: TripLocations) {
        self._controller = StateObject(wrappedValue: SelectedTripVM(tripLocations: tripLocations))
    }
    
    var header: some View {
        VStack {
            if controller.selectedTrip != nil {
                EmptyView()
                
            }
            EmptyView()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
        }
    }
}
