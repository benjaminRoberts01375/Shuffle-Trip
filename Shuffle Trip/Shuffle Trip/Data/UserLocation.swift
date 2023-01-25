// Jan 19, 2022
// Ben Roberts

import MapKit

final class UserLocation: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var onAuthorizationChanged: (() -> Void)?
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        print("Location manager setup is complete")
    }
    
    func checkLocationAuthorization() -> Bool {
        guard let locationManager = locationManager else {return false}
        
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            return false                                        // Defintely not enabled
        case .authorizedAlways, .authorizedWhenInUse:
            return CLLocationManager.locationServicesEnabled()  // Final check for if location services are enabled
        @unknown default:
            return false
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { // Permission changed or created
        print("Permission changed")
        
        guard let locationManager = locationManager else { return }
        locationManager.authorizationStatus == .notDetermined ? locationManager.requestWhenInUseAuthorization() : onAuthorizationChanged?()
    }
}
