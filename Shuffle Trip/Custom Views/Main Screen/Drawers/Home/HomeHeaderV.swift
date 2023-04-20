// Apr 20, 2023
// Benjamin Roberts

import SwiftUI

struct HomeHeaderV: View {
    @StateObject var controller: HomeHeaderVM
    init(tripLocations: TripLocations, region: RegionDetails, searchText: Binding<String>) {
        self._controller = StateObject(wrappedValue: HomeHeaderVM(tripLocations: tripLocations, region: region, searchText: searchText))
    }
    
    var body: some View {
        HStack {
            SearchBar(text: $controller.searchText, placeholder: "Find your next day trip...")
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
