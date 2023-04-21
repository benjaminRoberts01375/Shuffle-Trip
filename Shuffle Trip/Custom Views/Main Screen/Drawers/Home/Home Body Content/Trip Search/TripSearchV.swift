// Apr 21, 2023
// Ben Roberts

import SwiftUI

struct TripSearchV: View {
    @StateObject var controller: TripSearchVM
    
    init() {
        self._controller = StateObject(wrappedValue: TripSearchVM())
    }
    
    var body: some View {
        EmptyView()
    }
}
