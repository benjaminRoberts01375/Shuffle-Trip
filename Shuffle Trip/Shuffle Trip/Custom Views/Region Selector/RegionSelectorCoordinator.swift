// Jan 24, 2023
// Ben Roberts

import SwiftUI
import MapKit

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

class MapCoordinator: NSObject, MKMapViewDelegate {
    /// Current position and span of the map.
    @Binding var region: MKCoordinateRegion
    @ObservedObject var tripLocations: TripLocations
    
    init(region: Binding<MKCoordinateRegion>, tripLocations: TripLocations) {
        self._region = region
        self.tripLocations = tripLocations
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
            let selectedCircle = tripLocations.tripLocations.first(where: { $0.isSelected })
            
            if selectedCircle != nil && selectedCircle?.coordinate == overlay.coordinate {
                circleRenderer.fillColor = UIColor.systemRed.withAlphaComponent(0.3)
                circleRenderer.lineWidth = 5
            }
            else {
                circleRenderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.3)   // Set MKCircle color to blue with 30% opacity
                circleRenderer.lineWidth = 3
            }
            circleRenderer.strokeColor = .white                                         // Set MKCircle outline to white
            
            return circleRenderer                                                       // Return new appearance
        }
        else {
            return MKOverlayRenderer(overlay: overlay)                                  // Return default appearance
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
        
        if let trip = tripLocations.tripLocations.last(where: { tripLocation in
            return MKMapPoint(touchCoordinate).distance(to: MKMapPoint(tripLocation.coordinate)) < tripLocation.radius
        }) {
            tripLocations.RemoveTrip(trip: trip)
        }
        else {
            tripLocations.AddTrip(trip: TripLocation(coordinate: touchCoordinate))
        }
    }
    
    /// Check for any trips being short tapped on.
    /// - Parameter gestureRecognizer: Handles tap coordinates
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        /// The mapView to interact with
        let mapView = gestureRecognizer.view as! MKMapView                                                                                          // Get access to the mapView
        /// Location in screen space that was tapped on
        let location = gestureRecognizer.location(in: mapView)                                                                                      // Get the location on screen of the tap
        /// Coordinate of where the user tapped mapped to coordinates on the mapView
        let touchCoordinate = mapView.convert(location, toCoordinateFrom: mapView)                                                                  // Convert the screen location to the map location
        
        if tripLocations.tripLocations.isEmpty {                                                                                                    // There are no trips available to tap on, exit
            tripLocations.SelectTrip()
            return
        }
        /// When trips are shown as circles, this list is a list of all the circles that were tapped on, useful if there are overlapping circles.
        let tappedTrips = tripLocations.tripLocations.filter({ MKMapPoint(touchCoordinate).distance(to: MKMapPoint($0.coordinate)) < $0.radius })   // List of trips that were tapped on
                                                                                                                                                    // Handle easy conditions first
        if tappedTrips.isEmpty {                                                                                                                    // No trips were tapped on
            tripLocations.SelectTrip()
            return
        }
        
        if tappedTrips.count == 1 {                                                                                                                 // Check if only one was tapped, and manually set it
            tripLocations.SelectTrip(trip: tappedTrips[0])
            return
        }
        
        var index: Int = tappedTrips.lastIndex(where: { $0.isSelected }) ?? 0                                                                       // Of the tapped on trips, find the index of the one that's already selected
        index = (index + 1) % tappedTrips.count                                                                                                     // Go to the next trip
        tripLocations.SelectTrip(trip: tappedTrips[index])                                                                                          // Select the new trip
    }
}
