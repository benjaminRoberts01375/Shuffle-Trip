// Jan 24, 2023
// Ben Roberts

import SwiftUI
import MapKit

/// Renders a map and shows icons/annotations
struct RegionSelector: UIViewRepresentable {
    var userLocation: UserLocation = UserLocation() // This needs to be outside teh makeUIView function for... reasons? idk it doesn't work unless it is
    let logoPosition: CGFloat
    @State var region: MKCoordinateRegion = MapDetails.region1
    
    /// Configure map
    /// - Parameter context: Provided by system
    /// - Returns: A fully configured map
    func makeUIView(context: Context) -> some UIView {
        let mapView = MKMapView()
        mapView.layoutMargins.bottom = logoPosition + 5
        
        // Configure map
        let mapConfig = MKStandardMapConfiguration()
        mapConfig.pointOfInterestFilter = MapDetails.defaultFilter  // Remove items from map
        mapConfig.showsTraffic = false                              // Hide traffic
        mapView.preferredConfiguration = mapConfig
        mapView.region = region                                     // Set default region
        mapView.showsUserLocation = true                            // Show user
        mapView.showsScale = true                                   // Show scale when zooming
        mapView.showsCompass = true                                 // Show compass to reorient when not facing north
        
        // Setting up coordinator
        mapView.delegate = context.coordinator                      // Set the coordinator for the MapView
        
        // Getting the user's location
        userLocation.setupLocationManager()                         // Get permission from user to show on map
        userLocation.onAuthorizationChanged = {                     // If authorization changed, try to get the user's location. If unable, use defaults.
            region = MKCoordinateRegion(center: userLocation.locationManager?.location?.coordinate ?? mapView.centerCoordinate, latitudinalMeters: MapDetails.defaultRadius, longitudinalMeters: MapDetails.defaultRadius) // Get the user's region, and if unavailable, fallback to the current one
            mapView.setRegion(region, animated: true)
        }                // If user's preferences change, run this code to set map position accordingly
        
        // Setup long presses
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(MapCoordinator.handleLongPress(gestureRecognizer:)))   // Call function when long press happens
        mapView.addGestureRecognizer(longPressGestureRecognizer)                                                                                                            // Let the map know about long presses
        
        // Setup single taps
        let shortPressGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(MapCoordinator.handleTap(gestureRecognizer:)))
        mapView.addGestureRecognizer(shortPressGestureRecognizer)
        
        return mapView
    }
    
    /// Really doesn't get called except for when map is first made
    /// - Parameters:
    ///   - uiView: The map updated
    ///   - context: Provided by the system
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    /// Sets the coordinator for the Region Selector
    /// - Returns: A new MapCoordinator
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(region: $region)
    }
}

struct RegionSelector_Previews: PreviewProvider {
    static var previews: some View {
        RegionSelector(logoPosition: 0)
            .edgesIgnoringSafeArea(.all)
    }
}
