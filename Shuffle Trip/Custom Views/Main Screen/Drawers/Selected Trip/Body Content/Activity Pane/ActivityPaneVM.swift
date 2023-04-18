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
    
    /// Opens the look around experience at a given location
    public func openLookAround() {
        guard let activityDetails = activity.businesses?[0] else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(activityDetails.location.displayAddress.joined(separator: ", ")) { placemarks, error in   // Turn the display address into a set of coordinates. Had issues with longitude/latitude
            if error != nil {                                                                                                       // If not able to generate a placemark...
                return                                                                                                                  // Don't do anything
            }
            guard let placemark = placemarks?.first,                                                                                // Get the first placemark (there may be several locations)
                  let location = placemark.location?.coordinate                                                                     // Get the location of the first placemark
            else { return }                                                                                                         // If not able to, don't do anything
            self.lookAroundLocation = location                                                                                      // Set the look around coordinates
        }
        showLookAround = true                                                                                                   // Display the lookaround
    }
    
    /// Checks to see if look around is possible at the given location
    public func checkLookAround() {
        guard let location = tripLocations.locateActivityTrip(activity: activity)?.coordinate else { return }                           // Get the current activity's location
        Task {
            do {
                let possible = await LookAroundV.lookAroundPossible(location: location)                                                         // Determine if it's possible to show a look around experience
                DispatchQueue.main.async {                                                                                                      // On the main thread...
                    self.lookAroundPossible = possible                                                                                              // Track the possibility
                    if possible {                                                                                                                   // If it is possible...
                        self.lookAroundLocation = location                                                                                              // Store the location for lookaround
                    }
                }
            }
        }
    }
    
    /// Checks to see if an activity is valid for shuffling
    public func checkValidActivity() {
        if activity.tagIDs.isEmpty {    // If the tag is empty...
            allowShuffle = false            // ...Disallow shuffling
            return
        }
        allowShuffle = true             // Allow shuffling
    }
}
