// Mar 17, 2023
// Ben Roberts

import SwiftUI

struct TripErrorDV: DrawerView {
    @ObservedObject var controller: TripErrorVM
    
    init(tripLocations: TripLocations) {
        self._controller = ObservedObject(wrappedValue: TripErrorVM(tripLocations: tripLocations))
    }
    
    var header: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {    // Trash button
                    controller.deleteTrip()
                }, label: {
                    Image(systemName: "trash.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.red)
                        .font(Font.title.weight(.bold))
                })
                Button(action: {    // Try again button
                    controller.reshuffleTrip()
                }, label: {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                        .font(Font.title.weight(.bold))
                })
            }
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .padding(.horizontal, 1)
                    .foregroundStyle(Color.red)
                    .opacity(0.75)
                Text("Failed to generate trip")
                    .foregroundColor(.secondary)
                    .font(.body)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .textCase(.uppercase)
            }
            .padding(.top, 8)
        }
    }
    
    var body: some View {
        EmptyView()
    }
}

struct TripErrorDV_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RegionSelector(                     // Map
                logoPosition: 125,
                region: RegionDetails(),
                tripLocations: TripLocations()
            )
            
            BottomDrawer(                       // Drawer
                content: TripErrorDV(tripLocations: TripLocations()),
                snapPoints: [150, 1 / 2, 0.925]
            )
        }
        .ignoresSafeArea()
    }
}
