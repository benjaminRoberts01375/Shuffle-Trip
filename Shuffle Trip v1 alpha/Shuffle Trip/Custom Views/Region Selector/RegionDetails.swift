// Mar 10, 2023
// Ben Roberts

import MapKit
import SwiftUI

/// Workaround for allowing access to the current region without state update issues
final class RegionDetails {
    var region: MKCoordinateRegion = MapDetails.region1
}
