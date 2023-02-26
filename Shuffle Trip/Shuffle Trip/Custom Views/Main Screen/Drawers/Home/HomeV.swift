// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

struct HomeV: View {
    @StateObject var controller: HomeVM
    
    init(drawerController: DrawerController, tripLocations: TripLocations, region: Binding<MKCoordinateRegion>) {
        self._controller = StateObject(wrappedValue: HomeVM(userIsSearching: drawerController, tripLocations: tripLocations, region: region))
    }
    
    var body: some View {
        HStack {
            SearchBar(drawerController: controller.drawerController)
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
}
