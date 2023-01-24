//  December 22, 2022
// Ben Roberts

import Foundation
import MapKit

enum MapDetails {
    static let defaultFilter: MKPointOfInterestFilter = MKPointOfInterestFilter(excluding: [.atm, .bank, .evCharger, .fireStation, .gasStation, .hospital, .fitnessCenter, .laundry, .parking, .pharmacy, .police, .postOffice])
    
    static let spanFarDeg: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
    static let spanCloseDeg: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    
    static let location1: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 44.4759, longitude: -73.2121)
    static let region1: MKCoordinateRegion = MKCoordinateRegion(center: location1, latitudinalMeters: 10000, longitudinalMeters: 10000)
    static let title1: String = "Burlington"
    
    static let location2: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589)
    static let region2: MKCoordinateRegion = MKCoordinateRegion(center: location2, latitudinalMeters: 10000, longitudinalMeters: 10000)
    static let title2: String = "Boston"
}
