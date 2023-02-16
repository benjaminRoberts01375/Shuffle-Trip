// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var userIsSearching: SearchTracker = SearchTracker()
    @Published var tripLocations: TripLocations = TripLocations()
    @Published var region: MKCoordinateRegion = MapDetails.region2
    public let cardMinimumHeight: CGFloat = 100
}
