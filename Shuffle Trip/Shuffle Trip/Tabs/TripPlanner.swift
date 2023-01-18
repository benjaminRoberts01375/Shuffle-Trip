// Jan 15, 2023
// Ben Roberts


import SwiftUI

struct TripPlanner: View {
    @State var sheetUp: Bool = true
    var body: some View {
        ZStack {
            RegionSelector(region: MapDetails.region1)
                .edgesIgnoringSafeArea(.all)
            BottomCard()
        }
    }
}

struct TripPlanner_Previews: PreviewProvider {
    static var previews: some View {
        TripPlanner()
    }
}
