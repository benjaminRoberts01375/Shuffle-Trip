// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class SearchResultVM: ObservableObject {
    /// Location of something to do
    let locationResult: MKMapItem
    
    // swiftlint:disable cyclomatic_complexity function_body_length
    init(locationResult: MKMapItem) {
        self.locationResult = locationResult
    }
    // swiftlint:enable cyclomatic_complexity function_body_length
}
