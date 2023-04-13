// Apr 11, 2023
// Ben Roberts

import SwiftUI

final class TripConfiguratorVM: ObservableObject {
    /// Available trip locations
    var tripLocations: TripLocations
    /// The trip location to edit
    var selectedTrip: TripLocation!
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
    init(tripLocations: TripLocations) {
        self.tripLocations = tripLocations          // Assign the trip location to edit
        switch Locale.current.measurementSystem {   // Set units and ranges for distance slider
        case .metric, .uk:                              // UK also uses metric, I decided
            self.sliderMin = 2                              // Min of 2 kilometers to give small but reasonable range
            self.sliderMax = 40
            self.unitLabel = "km"
            self.isMetric = true
        default:                                        // Anyone else uses imperial, I decided
            self.sliderMin = 1.3                            // Approx. 2 kilometers
            self.sliderMax = 24
            self.unitLabel = "mi"
            self.isMetric = false
        }
        self.selectedTrip = tripLocations.getSelectedTrip()
        self.distanceSlider = 0
        self.distanceSlider = metersToSliderVal(selectedTrip.radius)
    }
    
    /// Set the trip's radius based on the slider's value
    internal func updateTripRadius() {
        selectedTrip.radius = sliderValToMeters()
    }
    
    /// Convert the value of the slider to meters based on a curve
    /// - Returns: Meters
    internal func sliderValToMeters() -> Double {
        let curve = pow(distanceSlider, 2) / 100                            // Curve the linear slider value
        let curvePercent = curve / 100                                      // Make value a percentage
        let unitVal = curvePercent * (sliderMax - sliderMin) + sliderMin    // Find the curved slider value in the min-max difference, then re-add the min. Note, this is in km or mi, not m
        return Measurement(value: unitVal, unit: isMetric ? UnitLength.kilometers : UnitLength.miles).converted(to: UnitLength.meters).value
    }
    
    /// Convert meters to an internal slider value
    /// - Parameter meters: Meters to convert
    /// - Returns: Value of the slider (0 to 100)
    internal func metersToSliderVal(_ meters: Double) -> Double {
        // The original equation is (x^2)/100, so undo it
        return round(pow(meters, 0.5) * 10) / 10  // Undoes the original equation and rounds it to one decimal place
    }
    
    /// Converts meters to either imperial or metric units based on the "isMetric" variable
    /// - Parameter meters: Meters to convert
    /// - Returns: The converted meters
    internal func metersToUnit(_ meters: Double) -> Double {
        return round(Measurement(                                                   // Round a measurement...
            value: meters,
            unit: UnitLength.meters                                                     // ...That's in meters
        )
            .converted(to: isMetric ? UnitLength.kilometers : UnitLength.miles)         // Convert it to either mi or km
            .value * 10) / 10                                                       // ...to the nearest decimal
    }
}
