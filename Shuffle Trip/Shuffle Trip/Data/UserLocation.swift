// Jan 19, 2022
// Ben Roberts

import MapKit

final class UserLocation: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var onAuthorizationChanged: (() -> Void)?
    var locationServicesEnabled: Bool = false
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { // Permission changed or created
        guard let locationManager = locationManager else { return }
        locationManager.authorizationStatus == .notDetermined ? locationManager.requestWhenInUseAuthorization() : onAuthorizationChanged?()
    }
}
