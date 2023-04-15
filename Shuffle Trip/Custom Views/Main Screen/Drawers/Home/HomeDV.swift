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
        HStack {
//            SearchBar()
            Button(
                action: {
                    controller.TripButton()
                },
                label: {
                    Image(systemName: "scope")
                        .font(Font.title2.weight(.regular))
                        .cornerRadius(5)
                }
            )
            Spacer()
        }
    }
    
    var body: some View {
        EmptyView()
    }
}
