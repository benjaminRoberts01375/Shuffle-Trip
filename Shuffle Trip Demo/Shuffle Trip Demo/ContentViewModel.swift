//
//  ContentViewModel.swift
//  Shuffle Trip Demo
//
//  Created by Roberts01, Benjamin on 11/29/22.
//

import MapKit

enum MapDetails {
    static let startingLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 44.4731, longitude: -73.2041)
    static let defaultSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() { // Check if location services are enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest // Default option, but I'm like that :)
            locationManager!.delegate = self
        }
        else { // Location services disabled
            // stub
        }
    }
    
    private func checkLocationAuthorization() { // Check permission to use location
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location is restricted because of parental controls... I think")
        case .denied:
            print("Location is required, please enable in settings")
        case .authorizedAlways, .authorizedWhenInUse: // Permission granted!
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)) // Update map region with current position coordinates
        @unknown default:
            break
        }
    }
    
    // Called by delegate
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
