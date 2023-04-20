// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

struct HomeDV: DrawerView {
    @ObservedObject var controller: HomeVM
    
    init(tripLocations: TripLocations, region: RegionDetails) {
        self._controller = ObservedObject(wrappedValue: HomeVM(tripLocations: tripLocations, region: region))
    }
    
    var header: some View {
        HomeHeaderV(tripLocations: controller.tripLocations, region: controller.region)
    }
    
    var body: some View {
        EmptyView()
    }
}
