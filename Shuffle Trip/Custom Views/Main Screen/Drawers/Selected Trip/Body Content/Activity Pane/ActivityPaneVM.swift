// Mar 20, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class ActivityPaneVM: ObservableObject {
    /// An activity to display
    @Published var activity: Activity
    /// Index of the activity within a  trip
    @Published var index: Int
    /// Trip locations for the current user
    @ObservedObject var tripLocations: TripLocations
    
    /// Init function for the Activity Pane view model
    /// - Parameters:
    ///   - activity: Activity to display
    ///   - index: Index of the activity within a trip
    init(activity: Activity, tripLocations: TripLocations) {
        self.activity = activity
        self.tripLocations = tripLocations
        self.index = 0
    }
    
    /// Determines the index of the activity within the selected trip
    public func generateIndex() {
        guard let selectedTrip = tripLocations.getSelectedTrip() else { return }
        self.index = (selectedTrip.activityLocations.firstIndex(of: activity) ?? 0) + 1
    }
    
    /// Removes an activity from the tripLocations
    public func removeActivity() {
        tripLocations.locateActivityTrip(activity: activity)?.removeActivity(activity: activity)
    }
    
    /// Shuffles a specific activity
    public func shuffleActivity() {
        tripLocations.locateActivityTrip(activity: activity)?.shuffleActivity(activity: activity)
    }
    
    /// Launch maps application for this activity
    public func openMaps() {
        guard let activityDetails = activity.businesses?[0] else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(activityDetails.location.displayAddress.joined(separator: ", ")) { placemarks, error in   // Turn the display address into a set of coordinates. Had issues with longitude/latitude
            if let error = error {
                print("Not able to geocode address")
                return
            }
            guard let placemark = placemarks?.first else { return }                                                             // Get the placemark
            let destination = MKMapItem(placemark: MKPlacemark(placemark: placemark))                                           // Create the destination
            destination.name = activityDetails.name                                                                             // Set the name
            destination.phoneNumber = activityDetails.phone                                                                     // Set the phone number
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]                        // Use user default directions
            MKMapItem.openMaps(with: [destination], launchOptions: launchOptions)                                               // Open maps with directions
        }
    }
}
