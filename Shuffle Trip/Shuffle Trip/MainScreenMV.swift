// Jan 24, 2023
// Ben Roberts

import SwiftUI

struct MainScreenMV: View {
    @State var search: String = ""
    @State var userIsSearching: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let cardSnapPositions: [CGFloat] = [150, geometry.size.height/2, geometry.size.height + geometry.safeAreaInsets.bottom - 10]
            
            ZStack {
                RegionSelector(logoPosition: (cardSnapPositions.min() ?? 500) - geometry.safeAreaInsets.bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Color.clear
                        .background(BlurView(style: .systemUltraThinMaterial, opacity: .constant(0.0)))
                        .frame(height: geometry.safeAreaInsets.top)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                BottomDrawer(
                    goFull: $userIsSearching,
                    height: cardSnapPositions[0],
                    snapPoints: cardSnapPositions,
                    content:
                        VStack {
                            SearchBar(userIsSearching: $userIsSearching)
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
