// Jan 24, 2023
// Ben Roberts

import MapKit
import SwiftUI

/// Renders a map and shows icons/annotations
struct RegionSelector: UIViewRepresentable {
    /// Keeps track of the user's location
    /// - important: Needs to be outside of the makeUIView because of a callback from the UserLocation class
    var userLocation: UserLocation = UserLocation()
    /// Define safe areas of the map to nudge the legal information
    let logoPosition: CGFloat
    /// Map to display
    let mapView = MKMapView()
    /// Where the map is currently displaying
    var region: RegionDetails
    /// All available trips from the user
    @ObservedObject var tripLocations: TripLocations
    
    /// Configure map
    /// - Parameter context: Provided by system
    /// - Returns: A fully configured map
    func makeUIView(context: Context) -> MKMapView {
        mapView.layoutMargins.bottom = logoPosition + 5
        
        // Configure map
        let mapConfig = MKStandardMapConfiguration()
        mapConfig.pointOfInterestFilter = MapDetails.defaultFilter  // Remove items from map
        mapConfig.showsTraffic = false                              // Hide traffic
        mapView.preferredConfiguration = mapConfig
        mapView.region = region.region                              // Set default region
        mapView.showsUserLocation = true                            // Show user
        mapView.showsScale = true                                   // Show scale when zooming
        mapView.showsCompass = true                                 // Show compass to reorient when not facing north
        
        // Setting up coordinator
        mapView.delegate = context.coordinator                      // Set the coordinator for the MapView
        
        // Getting the user's location
        userLocation.setupLocationManager()                         // Get permission from user to show on map
        userLocation.onAuthorizationChanged = {                     // If authorization changed, try to get the user's location. If unable, use defaults.
            region.region = MKCoordinateRegion(
                center: userLocation.locationManager?.location?.coordinate ?? mapView.centerCoordinate,
                latitudinalMeters: MapDetails.defaultRadius,
                longitudinalMeters: MapDetails.defaultRadius
            )                       // Get the user's region, and if unavailable, fallback to the current one
            mapView.setRegion(region.region, animated: true)
        }                // If user's preferences change, run this code to set map position accordingly
        
        // Call function when long press happens
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(MapCoordinator.handleLongPress(gestureRecognizer:)))
        // Let the map know about long presses
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
        // Call function when short press happens
        let shortPressGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(MapCoordinator.handleTap(gestureRecognizer:)))
        // Let the map know about short presses
        mapView.addGestureRecognizer(shortPressGestureRecognizer)
        
        return mapView
    }
    
    /// Really doesn't get called except for when map is first made
    /// - Parameters:
    ///   - uiView: The map updated
    ///   - context: Provided by the system
    func updateUIView(_ uiView: MKMapView, context: Context) {
        RedrawLocations(uiView)
    }
    
    /// Sets the coordinator for the Region Selector
    /// - Returns: A new MapCoordinator
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(region: region, tripLocations: tripLocations)
    }
    
    /// Re-add all trips to map to avoid MapKit weirdness
    func RedrawLocations(_ mapView: MKMapView) {
        // Clear all overlays
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        for trip in tripLocations.tripLocations where !trip.isSelected {            // Add all non-selected trips to map
            let circle = MKCircle(center: trip.coordinate, radius: trip.radius)
            trip.polyID = circle.hash
            mapView.addOverlay(circle)
        }
        
        for trip in tripLocations.tripLocations where trip.isSelected {             // Add all selected trips to map to ensure selected one is on top
            let circle = MKCircle(center: trip.coordinate, radius: trip.radius)
            trip.polyID = circle.hash
            mapView.addOverlay(circle)
            
            var index = 0
            for activity in trip.activityLocations {
                index += 1
                let annotation = MKPointAnnotation()
                guard let latitude = activity.businesses?[0].coordinates.latitude,
                      let longitude = activity.businesses?[0].coordinates.longitude,
                      let title = activity.businesses?[0].name else { continue }
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotation.title = title
                mapView.addAnnotation(annotation)
            }
        }
        
        if !mapView.overlays.isEmpty {                                              // Set the region to the last placed circle (likely the selected one)
            if let circle = mapView.overlays.last as? MKCircle {                    // Ensure that last item is an MKCircle
                
                let selectedIndex = tripLocations.tripLocations.firstIndex(where: { location in
                    circle.hash == location.polyID
                }) ?? -1
                
                if selectedIndex != -1 && tripLocations.tripLocations[selectedIndex].isSelected {
                    let zoomOutMultiplier = 2.2
                    mapView.setRegion(
                        MKCoordinateRegion(
                            center: circle.coordinate,
                            latitudinalMeters: circle.radius * zoomOutMultiplier,
                            longitudinalMeters: circle.radius * zoomOutMultiplier
                        ),
                        animated: true
                    )
                    return
                }
            }
        }
    }
}
