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
    
    internal func addActivity(activity: MKMapItem) {
        let placemark = activity.placemark
        guard let selectedTrip = tripLocations.getSelectedTrip(),
              let name = placemark.name,
              let number = placemark.subThoroughfare,
              let street = placemark.thoroughfare,
              let city = placemark.locality,
              let stateCode = placemark.administrativeArea,
              let countryCode = placemark.isoCountryCode
        else { return }
        
        let request: ActivityRequest = ActivityRequest(name: name, address: "\(number) \(street)", city: city, state: stateCode, country: countryCode)
        
        Task {
            do {
                let newBusiness = try await APIHandler.request(url: .requestActivity, dataToSend: request, decodeType: Business.self)
                let newActivity = Activity()
                for category in newBusiness.categories {
                    _ = newActivity.addTag(tagName: category.title)
                }
                newActivity.businesses = [newBusiness]
                selectedTrip.insertActivity(activity: newActivity)
            }
            catch APIHandler.Errors.decodeError {
                alertTracker = true
            }
        }
    }
}
