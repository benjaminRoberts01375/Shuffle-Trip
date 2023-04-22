// Apr 13, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class SelectedTripContentVM: ObservableObject {
    /// All available trip locations for the user
    @ObservedObject var tripLocations: TripLocations
    /// Keeps track of the current editing status for the user
    @ObservedObject var editingTracker: EditingTrackerM
    /// Keeps track of when to show the available settings for the trip
    @Published var showSettings: Bool
    /// Tracking details about search in regards to location
    @ObservedObject var searchTracker: LocationSearchTrackerM
    /// Keeps track of if an error should be displayed on the screen
    @Published var alertTracker: Bool
    
    init(tripLocations: TripLocations, editingTracker: EditingTrackerM) {
        self.tripLocations = tripLocations
        self.editingTracker = editingTracker
        self.showSettings = false
        self.searchTracker = LocationSearchTrackerM()
        self.alertTracker = false
    }
    
    // Check editing status
    internal func checkState() {
        self.objectWillChange.send()
    }
    
    /// Add an activity from a search result
    /// - Parameter activity: The result of the search
    internal func addActivity(activity: MKMapItem) {
        let placemark = activity.placemark                          // Store the placemark of the search result
        guard let selectedTrip = tripLocations.getSelectedTrip(),   // Get the selected trip
              let name = placemark.name,                            // Name of the placemark
              let number = placemark.subThoroughfare,               // House number of the placemark
              let street = placemark.thoroughfare,                  // Street of the placemark
              let city = placemark.locality,                        // City of the placemark
              let stateCode = placemark.administrativeArea,         // State code of the placemark
              let countryCode = placemark.isoCountryCode            // Country code of the placemark
        else { return }
        
        let request: ActivityRequest = ActivityRequest(             // Create a request for getting Yelp information
            name: name,                                                 // Name of the business
            address: "\(number) \(street)",                             // Street address of the business
            city: city,                                                 // City of the business
            state: stateCode,                                           // State code (initials) of the business
            country: countryCode                                        // Country code (initials) of the business
        )
        
        Task {                                                      // With async...
            do {
                let newBusiness = try await APIHandler.request(             // Store a business
                    url: .requestActivity,                                  // Use the requested URL
                    dataToSend: request,                                    // Use the pre-made request
                    decodeType: Business.self                               // Store in a Business struct, we don't get a full activity
                )
                let newActivity = Activity()                                // Create a new Activity
                for category in newBusiness.categories {                    // For each of the categories in the activity
                    _ = newActivity.addTag(tagName: category.title)             // Add the tagID to the activity
                }
                newActivity.businesses = [newBusiness]                      // Format the business into an array for the activity
                selectedTrip.insertActivity(activity: newActivity)          // Insert the activity into the tripLocations
            }
            catch APIHandler.Errors.decodeError {                       // Catch any decode errors...
                alertTracker = true                                         // And display a warning
            }
        }
    }
    
    internal func deleteTrip(trip: TripLocation) {
        //================================== DEMO TEMP ====================================
        tripLocations.AddTripDB(trip: trip)
        
        //tripLocations.RemoveTrip(trip: trip)
    }
    
    internal func finishTrip() {
        
    }
    /// Launch maps application for this activity
    public func openMaps() {
        guard let selectedTrip = tripLocations.getSelectedTrip() else { return }
        var destinations: [MKMapItem] = []
        
        for activity in selectedTrip.activityLocations {
            guard let address = activity.businesses?[0].location.displayAddress.joined(separator: ", ") else { continue }
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { placemarks, error in   // Turn the display address into a set of coordinates. Had issues with longitude/latitude
                if error != nil {
                    print("Not able to geocode address")
                    return
                }
                guard let placemark = placemarks?.first else { return }                                                             // Get the placemark
                let destination = MKMapItem(placemark: MKPlacemark(placemark: placemark))                                           // Create the destination
                destination.name = activity.businesses?[0].name                                                                             // Set the name
                destination.phoneNumber = activity.businesses?[0].phone                                                                     // Set the phone number
                destinations.append(destination)
            }
        }
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDefault]                        // Use user default directions
        MKMapItem.openMaps(with: destinations, launchOptions: launchOptions)                                               // Open maps with directions
    }
}
