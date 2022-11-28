//
//  ContentView.swift
//  Shuffle Trip Demo
//
//  Created by Ben Roberts on 11/26/22.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @StateObject private var viewModel = ContentViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 44.4731, longitude: -73.2041), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .ignoresSafeArea()
                .onAppear {
                    viewModel.checkIfLocationServicesIsEnabled()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest // Default option, but I'm like that :)
            locationManager!.delegate = self
            Alert(title: Text("Yay!"))
        }
        else {
            Alert(title: Text("No good."))
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location is restricted because of parental controls... I think")
        case .denied:
            print("Location is required, please enable in settings")
        case .authorizedAlways, .authorizedWhenInUse:
            break // Come back to this
        @unknown default:
            break
        }
    }
    
    // Called by delegate
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
