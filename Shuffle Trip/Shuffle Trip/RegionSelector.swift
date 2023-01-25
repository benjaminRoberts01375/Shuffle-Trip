// Jan 24, 2023
// Ben Roberts

import SwiftUI
import MapKit

struct RegionSelector: UIViewRepresentable {
    var userLocation: UserLocation = UserLocation() // This needs to be outside teh makeUIView function for... reasons? idk it doesn't work unless it is
    
    func makeUIView(context: Context) -> some UIView {
        let mapView = MKMapView()
        
        // Configure map
        let mapConfig = MKStandardMapConfiguration()
        mapConfig.pointOfInterestFilter = MapDetails.defaultFilter  // Remove items from map
        mapConfig.showsTraffic = false                              // Hide traffic
        mapView.preferredConfiguration = mapConfig
        mapView.region = MapDetails.region2                         // Set default region
        mapView.showsUserLocation = true                            // Show user
        mapView.showsScale = true                                   // Show scale when zooming
        mapView.showsCompass = true                                 // Show compass to reorient when not facing north
        
        // Setting up coordinator
        mapView.delegate = context.coordinator
        
        // Getting the user's location
        userLocation.setupLocationManager()                         // Get permission from user to show on map
        userLocation.onAuthorizationChanged = {
            DispatchQueue.main.async { // Check user location permissions async
                if userLocation.checkLocationAuthorization() {
                    mapView.setRegion(MKCoordinateRegion(center: userLocation.locationManager?.location?.coordinate ?? MapDetails.location2, latitudinalMeters: MapDetails.defaultRadius, longitudinalMeters: MapDetails.defaultRadius), animated: true)
                }
            }
        }                // If user's preferences change, run this code to set map position accordingly
        
        
        return mapView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("Hello world!")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {                // Base code inspired by ChatGPT, but *very* heavily modified
        var parent: RegionSelector
        
        init(_ parent: RegionSelector) {
            self.parent = parent
        }
    }
    
}


struct RegionSelector_Previews: PreviewProvider {
    static var previews: some View {
        RegionSelector()
            .edgesIgnoringSafeArea(.all)
    }
}
