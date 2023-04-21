// Apr 21, 2023
// Ben Roberts

import SwiftUI

struct SearchV: View {
    @StateObject var controller: SearchVM
    
    init(searchTracker: LocationSearchTrackerM, filter: Bool) {
        self._controller = StateObject(wrappedValue: SearchVM(searchTracker: searchTracker, filter: filter))
    }
    
    var body: some View {
        VStack {
            ForEach(controller.searchTracker.searchResults, id: \.self) { result in
                if !controller.filterEnabled ||
                    result.placemark.country != nil &&
                    result.placemark.administrativeArea != nil &&
                    result.placemark.subThoroughfare != nil {
                    SearchResultV(locationResult: result)
                        .padding(5)
                        .background(BlurView(style: .systemThinMaterial, opacity: 0))
                        .cornerRadius(7)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    Divider()
                }
            }
        }
        .onReceive(controller.searchTracker.$searchText) { searchQuery in
            controller.search(searchQuery)
        }
        .onReceive(controller.searchTracker.$searchResults) { _ in
            self.controller.objectWillChange.send()
        }
    }
}
