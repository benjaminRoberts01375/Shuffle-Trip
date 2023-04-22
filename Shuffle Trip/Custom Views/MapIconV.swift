//  Jan 8, 2023
// Ben Roberts

import MapKit
import SwiftUI

struct MapIconV: UIViewRepresentable, Identifiable {
    let id = UUID()
    let region: MKCoordinateRegion
    let activities: [Business]
    let title: String
    
    func makeUIView(context: Context) -> some UIView {
        // Setup map
        let mapView: MKMapView = MKMapView()
        mapView.setRegion(region, animated: false)
        mapView.pointOfInterestFilter = MapDetails.defaultFilter
        mapView.delegate = context.coordinator // Setup coordinator for map interactions
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false

        // Add pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = region.center
        annotation.title = title
        mapView.addAnnotation(annotation)

        var index = 0
        for activity in activities {
            index += 1
            let annotation = MKPointAnnotation()
            let latitude = activity.coordinates.latitude
            let longitude = activity.coordinates.longitude
            let title = activity.name
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = title
            mapView.addAnnotation(annotation)
            print("adding index \(index)")
        }
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, activities)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapIconV
        var activityLocations: [Business]
        
        init(_ parent: MapIconV, _ activityLocations: [Business]) {
            self.parent = parent
            self.activityLocations = activityLocations
        }
    }
}
