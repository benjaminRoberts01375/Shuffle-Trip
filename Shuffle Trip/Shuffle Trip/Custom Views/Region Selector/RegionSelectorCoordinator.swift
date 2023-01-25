// Jan 24, 2023
// Ben Roberts

import SwiftUI
import MapKit

class Coordinator: NSObject, MKMapViewDelegate { // Base code inspired by ChatGPT, but *very* heavily modified
    var parent: RegionSelector
    
    init(_ parent: RegionSelector) {
        self.parent = parent
    }
}
