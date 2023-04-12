// Apr 11, 2023
// Ben Roberts

import SwiftUI

final class TripConfiguratorVM: ObservableObject {
    /// The trip location to edit
    var tripLocation: TripLocation
    /// Distance presented on the distance slider
    @Published var distanceSlider: Double
    /// Maximum value for distance slider
    let sliderMax: Double
    /// Minimum value for distance slider
    let sliderMin: Double
    /// Distance label for distance slider
    let unitLabel: String
    /// Tracker for if measurements are in metric
    let isMetric: Bool
    
    /// Setup units and trip location for the trip configurator
    /// - Parameter tripLocation: Trip to edit
    init(tripLocation: TripLocation) {
        self.tripLocation = tripLocation            // Assign the trip location to edit
        switch Locale.current.measurementSystem {   // Set units and ranges for distance slider
        case .metric, .uk:                              // UK also uses metric, I decided
            self.sliderMin = 2                              // Min of 2 kilometers to give small but reasonable range
            self.sliderMax = 40
            self.unitLabel = "km"
            self.isMetric = true
            self.distanceSlider = tripLocation.radius / 1000
        default:                                        // Anyone else uses imperial, I decided
            self.sliderMin = 1.3                            // Approx. 2 kilometers
            self.sliderMax = 24
            self.unitLabel = "mi"
            self.isMetric = false
            self.distanceSlider = tripLocation.radius * 1.62 / 1000
        }
    }
    
    internal func updateTripRadius() {
        tripLocation.radius = distanceSlider * 1000 * (isMetric ? 1.61 : 1)
    }
}
