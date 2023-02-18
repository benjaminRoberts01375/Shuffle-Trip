// Feb 15, 2023
// Ben Roberts

import MapKit
import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var homeDrawerController: DrawerController
    @Published var tripDrawerController: DrawerController
    @Published var tripLocations: TripLocations
    @Published var region: MKCoordinateRegion
    public let cardMinimumHeight: CGFloat
    
    init() {
        self.homeDrawerController = DrawerController()
        self.tripDrawerController = DrawerController(isFull: false, isPresented: false)
        self.tripLocations = TripLocations()
        self.region = MapDetails.region2
        self.cardMinimumHeight = 100
        
        tripLocations.AddTripLocationAcion {
            var isASelectedTrip: Bool = false
            for trip in self.tripLocations.tripLocations {
                if trip.isSelected {
                    isASelectedTrip = true
                    break
                }
            }
            self.tripDrawerController.isPresented = isASelectedTrip
        }
    }
}
