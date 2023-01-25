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
        
        userLocation.setupLocationManager()                         // Get permission from user to show on map
        
        userLocation.onAuthorizationChanged = {                     // If user's preferences change, run this code to set map position accordingly
            DispatchQueue.main.async { // Check user location permissions async
                if userLocation.checkLocationAuthorization() {
                    mapView.setRegion(MKCoordinateRegion(center: userLocation.locationManager?.location?.coordinate ?? MapDetails.location2, latitudinalMeters: MapDetails.defaultRadius, longitudinalMeters: MapDetails.defaultRadius), animated: true)
                    print("Executed")
                }
            }
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("Hello world!")
    }
}


struct RegionSelector_Previews: PreviewProvider {
    static var previews: some View {
        RegionSelector()
            .edgesIgnoringSafeArea(.all)
    }
}
