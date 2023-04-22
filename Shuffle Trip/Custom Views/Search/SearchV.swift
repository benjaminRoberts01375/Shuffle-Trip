// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

struct SearchV: View {
    @StateObject var controller: SearchVM
    
    init(searchTracker: LocationSearchTrackerM, filter: Bool, selectionAction: @escaping (MKMapItem) -> Void) {
        self._controller = StateObject(wrappedValue: SearchVM(searchTracker: searchTracker, filter: filter, selectionAction: selectionAction))
    }
    
    var body: some View {
        VStack {
            ForEach(controller.searchTracker.searchResults, id: \.self) { result in
                if !controller.filterEnabled ||                     // If the filter's enabled...
                    result.placemark.country != nil &&                  // Check for the country,
                    result.placemark.administrativeArea != nil &&       // State,
                    result.placemark.subThoroughfare != nil {           // and house number
                    Button(action: {
                        controller.selectionAction(result)
                    }, label: {
                        SearchResultV(locationResult: result)
                            .padding(5)
                            .background(BlurView(style: .systemThinMaterial, opacity: 0))
                            .cornerRadius(7)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    })
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
