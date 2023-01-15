//  Jan 8, 2023
// Ben Roberts

import SwiftUI
import MapKit

struct MapIcon: UIViewRepresentable, Identifiable {
    let id = UUID()
    let region: MKCoordinateRegion
    let pinImage: UIImage
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

        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print("Here")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, pinImage)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapIcon
        let pinImage: UIImage
        
        init(_ parent: MapIcon, _ pinImage: UIImage) {
            self.parent = parent
            self.pinImage = pinImage
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Return nil if the annotation is not of type MKPointAnnotation (we only want to customize the appearance of MKPointAnnotation)
            if let annotation = annotation as? MKPointAnnotation {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "genericAnnotationView") as? MKMarkerAnnotationView

                if annotationView == nil {
                    // Create a new annotation view if one cannot be dequeued
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "genericAnnotationView")
                } else {
                    // Update the annotation view's annotation and other properties
                    annotationView?.annotation = annotation
                }

                annotationView?.glyphImage = pinImage // Set the image of the annotation view to the "scooter" image
                annotationView?.isEnabled = false // Prevent interactions with pin
                return annotationView
            }
            return nil
        }
    }
}

struct MapIcon_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
