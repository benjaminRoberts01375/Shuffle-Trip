// Apr 12, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripContentV: View {
    /// Locations of each trip
    var tripLocations: TripLocations
    /// Selected trip from trip locations
    @State var selectedTrip: TripLocation!
    /// Manages the content being shown in the drawer body
    @State var contentType: ContentType
    
    /// The initializer for the selected trip content manager
    /// - Parameter tripLocations: Locations of each trip
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
        contentType = .info
    }
    
    enum ContentType {
        /// Display information about the trip
        case info
        /// Display the trip configurator
        case settings
    }
    
    /// Sets the cache for the selected trip based on what trip is found to be selected in TripLocations
    private func setSelectedTrip() {
        selectedTrip = tripLocations.tripLocations.first(where: { $0.isSelected }) ?? selectedTrip
    }
    
    var body: some View {
        if selectedTrip != nil {
            VStack {
                switch contentType {
                case .info:
                    EmptyView()
                case .settings:
                    TripConfiguratorV(tripLocations: tripLocations)
                }
            }
            .onReceive(tripLocations.objectWillChange) { _ in
                selectedTrip = tripLocations.getSelectedTrip() ?? selectedTrip  // Set the selected trip
                contentType = .info                                             // Change the displayed content back to info
            }
        }
        else {
            EmptyView()
        }
    }
}

struct SelectedTripContent_Previews: PreviewProvider {
    static var previews: some View {
        SelectedTripContentV(tripLocations: TripLocations())
    }
}
