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
    /// Determines if it's possible to show look around at the location
    @Published var lookAroundPossible: Bool
    /// Tracks if the look around experience is currently open
    @Published var showLookAround: Bool
    /// Location of the look around experience
    @Published var lookAroundLocation: CLLocationCoordinate2D
    /// Determines if the user is allowed to shuffle this activity
    @Published var allowShuffle: Bool
    /// Determines if the tag picker sheet is shown
    @Published var showTagSelector: Bool
    
    /// Init function for the Activity Pane view model
    /// - Parameters:
    ///   - activity: Activity to display
    ///   - index: Index of the activity within a trip
    init(activity: Activity, tripLocations: TripLocations) {
        self.activity = activity
        self.tripLocations = tripLocations
        self.index = 0
        self.lookAroundPossible = false
        self.showLookAround = false
        self.allowShuffle = false
        self.showTagSelector = false
        self.lookAroundLocation = MapDetails.location1
        checkLookAround()
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
            if error != nil {
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
    
    public func openLookAround() {
        guard let activityDetails = activity.businesses?[0] else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(activityDetails.location.displayAddress.joined(separator: ", ")) { placemarks, error in   // Turn the display address into a set of coordinates. Had issues with longitude/latitude
            if error != nil {
                print("Not able to geocode address")
                return
            }
            guard let placemark = placemarks?.first,
                  let location = placemark.location?.coordinate
            else { return }
            self.lookAroundLocation = location
            
        }
        showLookAround = true
    }
    
    public func checkLookAround() {
        guard let location = tripLocations.locateActivityTrip(activity: activity)?.coordinate else { return }
        Task {
            do {
                let possible = await LookAroundV.lookAroundPossible(location: location)
                DispatchQueue.main.async {
                    self.lookAroundPossible = possible
                    if possible {
                        guard let location = self.tripLocations.locateActivityTrip(activity: self.activity)?.coordinate else { return }
                        print("Old loc:   \(self.lookAroundLocation.latitude), \(self.lookAroundLocation.longitude)")
                        self.lookAroundLocation = location
                        print("New loc:   \(self.lookAroundLocation.latitude), \(self.lookAroundLocation.longitude)")
                        print("Should be: \(location.latitude), \(location.longitude)")
                    }
                }
            }
        }
    }
    
    public func checkValidActivity() {
        if activity.tagIDs.isEmpty {
            allowShuffle = false
        }
        allowShuffle = true
    }
}
