//  December 22, 2022
// Ben Roberts

import SwiftUI
import MapKit

struct RegionSelector: UIViewRepresentable {
    let region: MKCoordinateRegion
    let pinImage: UIImage?
    let pinCoordinate: CLLocationCoordinate2D?
    var defaultRadius: CLLocationDistance {
        if Locale.current.measurementSystem == .metric {
            return Measurement(value: 5, unit: UnitLength.kilometers).converted(to: UnitLength.meters).value
        } else {
            return Measurement(value: 3, unit: UnitLength.miles).converted(to: UnitLength.meters).value
        }
    }
    
    init(region: MKCoordinateRegion, pinImage: UIImage?, pinCoordinate: CLLocationCoordinate2D?) {
        self.region = region
        self.pinImage = pinImage
        self.pinCoordinate = pinCoordinate
    }
    
    init(region: MKCoordinateRegion) {
        self.region = region
        self.pinImage = nil
        self.pinCoordinate = nil
    }
    
    
    func makeUIView(context: Context) -> some UIView {
        // Setup map
        let mapView = MKMapView()
        mapView.region = region // Set where map is centered and zoomed
        mapView.selectableMapFeatures = [.pointsOfInterest] // Allow selection of points of interest
        mapView.pointOfInterestFilter = MapDetails.defaultFilter // Don't show these kinds of places on map
        mapView.showsScale = true // Shows how far distance is
        mapView.showsCompass = true // Show where the user currently is if the permission allows
        mapView.delegate = context.coordinator // Setup coordinator for map interactions
        
        // Setup long presses
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        // Setup pinches
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePinch(gestureRecognizer:)))
        pinchGestureRecognizer.delegate = context.coordinator
        mapView.addGestureRecognizer(pinchGestureRecognizer)
        
        if let pinCoordinate = pinCoordinate, let _ = pinImage { // Ensure both the coordinate and image are not nil
            mapView.addOverlay(MKCircle(center: pinCoordinate, radius: defaultRadius)) // Add circle
            let annotation = MKPointAnnotation()
            annotation.coordinate = pinCoordinate
            mapView.addAnnotation(annotation) // Add pin
        }

        return mapView
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("Updated UI View")
    }
    
    /**
     A part of the UIRepresentable Protocol
     */
    func makeCoordinator() -> Coordinator {
        Coordinator(self, defaultRadius: defaultRadius, pinImage: pinImage)
    }
    
    /**
     An "in-between" for the map and SwiftUI code
     */
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate { // Inspired by ChatGPT (heavily modified)
        let pinImage: UIImage?
        let defaultRadius: CLLocationDistance
        var parent: RegionSelector
        var startingRad: Double = 0.0 // For pinching
        
        init(_ parent: RegionSelector, defaultRadius: CLLocationDistance, pinImage: UIImage?) {
            self.parent = parent
            self.defaultRadius = defaultRadius
            self.pinImage = pinImage
        }
        
        /**
         Render a blue circle around where the trip will be done
         */
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circleOverlay = overlay as? MKCircle { // If the overlay in question is a MKCircle, unwrap it and assign it to circleOverlay
                let circleRenderer = MKCircleRenderer(circle: circleOverlay)
                circleRenderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.3) // Set the alpha component to 0.5 to make the fill color 50% transparent.
                circleRenderer.strokeColor = .white
                circleRenderer.lineWidth = 5
                return circleRenderer
            } else {
                return MKOverlayRenderer(overlay: overlay)
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Return nil if the annotation is not of type MKPointAnnotation (we only want to customize the appearance of MKPointAnnotation)
            if let annotation = annotation as? MKPointAnnotation, let pinImage = pinImage {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "scooterAnnotationView") as? MKMarkerAnnotationView
                
                if annotationView == nil {
                    // Create a new annotation view if one cannot be dequeued
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "scooterAnnotationView")
                } else {
                    // Update the annotation view's annotation and other properties
                    annotationView?.annotation = annotation
                }
                
                // Set the image of the annotation view to the "scooter" image
                annotationView?.glyphImage = pinImage
                return annotationView
            }
            
            for overlay in mapView.overlays {
                if let circle = overlay as? MKCircle {
                    if (circle.coordinate.longitude == annotation.coordinate.longitude) && (circle.coordinate.latitude == annotation.coordinate.latitude) { // Check if circle already exists at annotation
                        return nil
                    }
                }
            }
            mapView.addOverlay(MKCircle(center: annotation.coordinate, radius: defaultRadius)) // If not found, make a new circle
            return nil
        }
        
        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state != .began { // Short circuit
                return
            }

            let mapView = gestureRecognizer.view as! MKMapView
            let location = gestureRecognizer.location(in: mapView)
            let touchCoordinate = mapView.convert(location, toCoordinateFrom: mapView)
            let MKTouchCoordinate = MKMapPoint(touchCoordinate)

            for overlay in mapView.overlays.reversed() { // Always remove the top-most circle
                if let circle = overlay as? MKCircle { // Convert generic overlay to MKCircle for access to circle specific functions
                    let distance = MKTouchCoordinate.distance(to: MKMapPoint(circle.coordinate)) // Determine distance between gesture and circle's center
                    if distance <= circle.radius {
                        mapView.removeOverlay(overlay) // Remove the circle if the gesture's within the radius
                        return // Short circuit
                    }
                }
            }

            mapView.addOverlay(MKCircle(center: touchCoordinate, radius: defaultRadius)) // If not found, make a new circle
        }

        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        /**
         Allow for pinching on a MKCircle to resize it
         */
        @objc func handlePinch(gestureRecognizer: UIPinchGestureRecognizer) {
            let mapView = gestureRecognizer.view as! MKMapView
            let location = gestureRecognizer.location(in: mapView)
            let touchCoordinate = mapView.convert(location, toCoordinateFrom: mapView)
            let MKTouchCoordinate = MKMapPoint(touchCoordinate)

            // Check each overlay for gesture being within circle's radius
            for overlay in mapView.overlays {
                if let circle = overlay as? MKCircle { // Convert generic overlay to MKCircle for access to circle specific functions
                    let distance = MKTouchCoordinate.distance(to: MKMapPoint(circle.coordinate)) // Calculate distance between gesture and circle location
                    if distance <= circle.radius { // If the distance to circle is less-than or equal to circle's radius
                        switch gestureRecognizer.state {
                        case .began: // Setup map to not move
                            mapView.isZoomEnabled = false
                            mapView.isScrollEnabled = false
                            mapView.isRotateEnabled = false
                            startingRad = circle.radius
                        case .changed: // When the fingers move, swap out the circle for a newly sized one
                            let newRadius = startingRad * Double(gestureRecognizer.scale)
                            let newCircle = MKCircle(center: circle.coordinate, radius: newRadius)
                            mapView.removeOverlay(overlay)
                            mapView.addOverlay(newCircle)
                        default: // Weird other conditions
                            break
                        }
                    }
                }
            }
            // Reset the map
            mapView.isZoomEnabled = true
            mapView.isScrollEnabled = true
            mapView.isRotateEnabled = true
        }
    }
}


struct RegionSelector_Previews: PreviewProvider {
    static var previews: some View {
        RegionSelector(region: MapDetails.region1)
            .ignoresSafeArea(.all)
    }
}
