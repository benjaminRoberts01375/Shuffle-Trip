// Jan 24, 2023
// Ben Roberts

import SwiftUI

struct MainScreenMV: View {
    var body: some View {
        RegionSelector()
            .edgesIgnoringSafeArea(.all)
    }
}

struct MainScreenMV_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenMV()
    }
}
