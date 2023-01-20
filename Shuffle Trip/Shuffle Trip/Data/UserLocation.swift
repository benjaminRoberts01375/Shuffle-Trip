// Jan 19, 2022
// Ben Roberts

import MapKit

final class UserLocation: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() { // Are location services enabled in general
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            print("Location services are enabled")
        }
        else {
            print("Location services are currently disabled :(")
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else {return}
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            print("that's fine. no perms")
        case .restricted: // Parental controls?
            print("Location controls restricted")
        case .authorizedAlways:
            print("lots of location!")
        case .authorizedWhenInUse:
            print("Great! Here you are!")
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { // Permission changed or created
        print("Permission changed")
        checkLocationAuthorization()
    }
}
