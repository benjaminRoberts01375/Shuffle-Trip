// Jan 24, 2023
// Ben Roberts

import SwiftUI
import MapKit

struct RegionSelector: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let mapView = MKMapView()
        
        DispatchQueue.main.async { // Check user location permissions async
            let userLocation = UserLocation()
            if userLocation.checkIfLocationServicesIsEnabled() {
                mapView.setRegion(MKCoordinateRegion(center: userLocation.locationManager?.location?.coordinate ?? MapDetails.location2, latitudinalMeters: MapDetails.defaultRadius, longitudinalMeters: MapDetails.defaultRadius), animated: true)
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
