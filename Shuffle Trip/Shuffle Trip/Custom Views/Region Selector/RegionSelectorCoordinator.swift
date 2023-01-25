// Jan 24, 2023
// Ben Roberts

import SwiftUI
import MapKit

class Coordinator: NSObject, MKMapViewDelegate { // Base code inspired by ChatGPT, but *very* heavily modified
    var parent: RegionSelector
    
    init(_ parent: RegionSelector) {
        self.parent = parent
    }
    
    /**
     How to render MKCircles. This is usually called per overlay when that overlay is created.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // If the overlay in question is a MKCircle, unwrap it and assign it to circleOverlay
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.3)
            circleRenderer.strokeColor = .white
            circleRenderer.lineWidth = 5
            return circleRenderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    /**
     Creation and deletion of circles on the map
     */
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began { // Short circuit
            return
        }
        
        // Getting the mapView and position of long press on map
        let mapView = gestureRecognizer.view as! MKMapView                              // Get the mapView from the gestureRecognizer
        let location = gestureRecognizer.location(in: mapView)                          // Get the location on screen of the tap
        let touchCoordinate = mapView.convert(location, toCoordinateFrom: mapView)      // Convert the screen location to the map location
        let MKTouchCoordinate = MKMapPoint(touchCoordinate)                             // Convert the datatype to a MKMapPoint
        
        // Remove a circle via long pressing on it
        for overlay in mapView.overlays.reversed() {                                            // Reverse order to remove top most circle
            if let circle = overlay as? MKCircle {                                              // Convert generic overlay to MKCircle for access to circle specific functions
                let distance = MKTouchCoordinate.distance(to: MKMapPoint(circle.coordinate))    // Determine distance between gesture and circle's center
                if distance <= circle.radius {
                    mapView.removeOverlay(overlay)                                              // Remove the circle if the gesture's within the radius
                    return                                                                      // Short circuit
                }
            }
        }
        
        // Add an MKCircle if we got this far
        mapView.addOverlay(MKCircle(center: touchCoordinate, radius: MapDetails.defaultRadius))
    }
}
