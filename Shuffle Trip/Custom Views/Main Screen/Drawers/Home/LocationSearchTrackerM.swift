// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class LocationSearchTrackerM: ObservableObject {
    /// What the user is searching for
    var searchText: String {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        self.searchText = ""
    }
            print("Responses: \(response.mapItems)")
            
        }
    }
}
