// Jan 24, 2023
// Ben Roberts

import SwiftUI
import MapKit

class MapCoordinator: NSObject, MKMapViewDelegate {
    /// Current position and span of the map.
    @Binding var region: MKCoordinateRegion
    var selectedCircle: MKCircle?
    
    init(region: Binding<MKCoordinateRegion>) {
        self._region = region
    }
    
    /// How to render MKCircles. This is usually called per overlay when that overlay is created.
    /// - Parameters:
    ///   - mapView: The MapView being updated
    ///   - overlay: The overlay to change the rendering for
    /// - Returns: Either the adjusted or original overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // If the overlay in question is a MKCircle, unwrap it and assign it to circleOverlay
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.3)   // Set MKCircle color to blue with 30% opacity
            circleRenderer.strokeColor = .white                                     // Set MKCircle outline to white
            circleRenderer.lineWidth = 5                                            // Set MKCircle outline width to 5pt
            mapView.setRegion(MKCoordinateRegion(center: circleOverlay.coordinate, latitudinalMeters: circleOverlay.radius * 2.2, longitudinalMeters: circleOverlay.radius * 2.2), animated: true)
            return circleRenderer                                                   // Return new appearance
        }
        else {
            return MKOverlayRenderer(overlay: overlay)                              // Return default appearance
        }
    }
    
    /// Called by a long press gesture, handles placing map locations
    /// - Parameter gestureRecognizer: Context for the long press
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began { // Short circuit
            return
        }
        
        // Getting the mapView and position of long press on map
        let mapView = gestureRecognizer.view as! MKMapView                                                      // Get the mapView from the gestureRecognizer
        let location = gestureRecognizer.location(in: mapView)                                                  // Get the location on screen of the tap
        let touchCoordinate = mapView.convert(location, toCoordinateFrom: mapView)                              // Convert the screen location to the map location
        
        // Add or remove trip locations
        if let circle = mapView.overlays.last(where: { overlay in                                               // Instead of iterating over each overlay, grab the one that meets this criteria. Use last to get highest/latest circle (expected behavior)
            guard let mkCircle = overlay as? MKCircle else { return false }                                     // Ensure that the circle is an MKCircle
            return MKMapPoint(touchCoordinate).distance(to: MKMapPoint(mkCircle.coordinate)) <= mkCircle.radius // Return the condition of if the long press happened within the MKCircle
        }) {
            mapView.removeOverlay(circle)                                                                       // If the condition was true, remove the circle
            selectedCircle = nil
        }
        else {
            let newCircle = MKCircle(center: touchCoordinate, radius: MapDetails.defaultRadius)
            selectedCircle = newCircle
            print(selectedCircle!)
            mapView.addOverlay(newCircle)                                                                       // If the condition was false, add a circle
        }
    }
    
    
    /// Check for any trips being tapped on.
    /// - Parameter gestureRecognizer: Handles tap coordinates
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let mapView = gestureRecognizer.view as! MKMapView                                                      // Get access to the mapView
        let location = gestureRecognizer.location(in: mapView)                                                  // Get the location on screen of the tap
        let touchCoordinate = mapView.convert(location, toCoordinateFrom: mapView)                              // Convert the screen location to the map location
        
        let testOverlays = mapView.overlays.filter({ overlay in                                                 // Create an array of overlays...
            if let circle = overlay as? MKCircle {
                if MKMapPoint(touchCoordinate).distance(to: MKMapPoint(circle.coordinate)) < circle.radius {    // ...that are known to conform to MKCircle and overlap with the user's tap
                    return true
                }
            }
            return false
        })
        
        if testOverlays.isEmpty {                                                                               // No circle was tapped on
            selectedCircle = nil
            return
        }
        else if testOverlays.count == 1 {                                                                       // Only circle was tapped on
            selectedCircle = testOverlays[0] as? MKCircle
            return
        }
                                                                                                                // There are at least 2 circles tapped on
        var index = testOverlays.lastIndex(where: { overlay in                                                  // Index of selectedCircle in the testOverlays array
            return (overlay as? MKCircle) == selectedCircle
        })!                                                                                                     // Always able to unwrap due to previous checks for 0 and 1 element(s)
        
        index = (index + 1) % testOverlays.count                                                                // Go to the next index, and loop when at end
        selectedCircle = testOverlays[index] as? MKCircle
    }
}
