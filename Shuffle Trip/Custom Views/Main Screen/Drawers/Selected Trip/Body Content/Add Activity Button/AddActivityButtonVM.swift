// Apr 14, 2023
// Ben Roberts

import SwiftUI

final class AddActivityButtomVM: ObservableObject {
    let index: Int
    let tripLocations: TripLocations
    
    
    init(tripLocations: TripLocations, index: Int) {
        self.tripLocations = tripLocations
        self.index = index
    }
    
    
    internal func addActivity() {
        
    }
}
