// Feb 17, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripV: DrawerView {
    @StateObject var controller: SelectedTripVM
    
    init(tripLocations: TripLocations) {
        self._controller = StateObject(wrappedValue: SelectedTripVM(tripLocations: tripLocations))
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("Selected trip header")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Selected trip here")
        }
    }
}
