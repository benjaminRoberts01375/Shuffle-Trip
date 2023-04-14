// Apr 13, 2023
// Ben Roberts

import SwiftUI

final class SelectedTripContentVM: ObservableObject {
    @ObservedObject var tripLocations: TripLocations
    @Published var showSettings: Bool
    
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations
        self.showSettings = false
    }
}
