// Mar 17, 2023
// Ben Roberts

import SwiftUI

struct LoadingTripDV: DrawerView {
    var header: some View {
        HStack {
            ProgressView()
                .padding(.trailing, 1)
            Text("Generating Trip")
                .foregroundColor(.secondary)
                .font(.body)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .textCase(.uppercase)
        }
        .onAppear {
            print("Loaded")
        }
    }
    
    var body: some View {
        EmptyView()
    }
}

struct LoadingTripV_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RegionSelector(                     // Map
                logoPosition: 125,
                region: RegionDetails(),
                tripLocations: TripLocations()
            )
            
            BottomDrawer(                       // Drawer
                content: LoadingTripDV(),
                snapPoints: [150, 1 / 2, 0.925]
            )
        }
        .ignoresSafeArea()
    }
}
