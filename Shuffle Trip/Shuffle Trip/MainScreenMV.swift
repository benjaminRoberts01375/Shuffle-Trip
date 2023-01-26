// Jan 24, 2023
// Ben Roberts

import SwiftUI

struct MainScreenMV: View {
    @State var search: String = ""
    var body: some View {

        GeometryReader { geometry in
            let cardSnapPositions: [CGFloat] = [500, geometry.size.height/4, geometry.size.height/3, geometry.size.height/2, geometry.size.height + geometry.safeAreaInsets.bottom]

            ZStack {
                RegionSelector(logoPosition: cardSnapPositions[0] - geometry.safeAreaInsets.bottom)
                    .edgesIgnoringSafeArea(.all)
                BottomDrawer(height: cardSnapPositions[0], snapPoints: cardSnapPositions, content:
                    VStack {
                        SearchBar()
                    }
                )
            }

        }
    }
}

struct MainScreenMV_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenMV()
    }
}
