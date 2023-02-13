// Feb 12, 2022
// Ben Roberts

import SwiftUI
import MapKit

/// Class defining where a trip takes place, as well as its details
public class TripLocation {
    /// Location of the trip
    var coordinate: CLLocationCoordinate2D
    /// How far fro the location does teh trip span
    var radius: CGFloat = MapDetails.defaultRadius
    /// Activities to be had at the trip
    var activityLocations: [Activity] = [] // TODO: Call to server to generate activites
    /// User has selected this trip for editing/viewing
    var isSelected: Bool = true
    /// An unique identifier for each trip
    let id = UUID()
    /// ID for polygon
    var polyID = 0
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    /// Something for the user to do during their trip
    struct Activity {
        /// Start date and time
        let start: DateComponents
        /// End date and time
        let end: DateComponents
        /// Where the activity is
        let location: CLLocationCoordinate2D
    }
}

extension TripLocation: Equatable {
    public static func == (lhs: TripLocation, rhs: TripLocation) -> Bool {
        return lhs.id == rhs.id
    }
}
