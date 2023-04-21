// Apr 21, 2023
// Ben Roberts

import SwiftUI

struct TripSearchV: View {
    @StateObject var controller: TripSearchVM
    
    init(searchTracker: LocationSearchTrackerM) {
        self._controller = StateObject(wrappedValue: TripSearchVM(searchTracker: searchTracker))
    }
    
    var body: some View {
        VStack {
            EmptyView()
        }
        .onReceive(controller.searchTracker.$searchText) { _ in
            controller.searchTracker.searchLocation()
        }
    }
}
