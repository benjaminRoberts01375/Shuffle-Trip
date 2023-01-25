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
        
        if let circle = mapView.overlays.last(where: { overlay in                                               // Instead of iterating over each overlay, grab the one that meets this criteria. Use last to get highest/latest circle (expected behavior)
            guard let mkCircle = overlay as? MKCircle else { return false }                                     // Ensure that the circle is an MKCircle
            return MKMapPoint(touchCoordinate).distance(to: MKMapPoint(mkCircle.coordinate)) <= mkCircle.radius // Return the condition of if the long press happened within the MKCircle
        }) {
            mapView.removeOverlay(circle)                                                                       // If the condition was true, remove the circle
        }
        else {
            mapView.addOverlay(MKCircle(center: touchCoordinate, radius: MapDetails.defaultRadius))             // If the condition was false, add a circle
        }
    }
}
