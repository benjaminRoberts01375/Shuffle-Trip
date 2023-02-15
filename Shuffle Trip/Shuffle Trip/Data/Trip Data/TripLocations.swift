// Jan 25, 2023
// Ben Roberts

import MapKit
import SwiftUI

/// Object for keeping track of trip locations and their status
final class TripLocations: ObservableObject {
    /// List of specified trip locations
    private(set) var tripLocations: [TripLocation] = []
    
    /// List of closures to execute when the list of trips or activities are updated.
    private var todoList: [() -> Void] = []
    
    /// Standardized method for updating any struct/class that have requested notifications for when this class changes
    private func SendUpdates() {
        for action in todoList {
            action()
        }
    }
    
    /// Standardized method of setting the selected trip
    /// - Parameter trip: Trip to set as selected
    private func SetSelectedTrip(trip: TripLocation?) {
        for tripLocation in tripLocations {
            tripLocation.isSelected = tripLocation == trip
        }
        SendUpdates()
    }
    
    /// Add code to be called when the trip locations are updated. This can happenw when any of the available variables change.
    /// - Parameter action: Closure that is called when trip locations are added.
    public func AddTripLocationAcion(action: @escaping () -> Void) {
        todoList.append(action)
    }
    
    /// Adds a new trip location and selects it
    /// - Warning: Trips cannot have the same location, and duplicate locations will be discarded.
    /// - Parameter trip: Trip to add
    public func AddTrip(trip: TripLocation) {
        if !tripLocations.contains(where: { $0.coordinate == trip.coordinate }) {
            tripLocations.append(trip)
            SelectTrip(trip: trip)
        }
    }
    
    /// Remove specified trip
    /// - Parameter trip: Trip to remove
    public func RemoveTrip(trip: TripLocation) {
        tripLocations.removeAll(where: { tripLocation in
            return tripLocation == trip
        })
    }
    
    /// Sets which trip should be selected to stand out from rest of trips.
    /// - Parameter trip: Trip to be selected
    public func SelectTrip(trip: TripLocation) {
        SetSelectedTrip(trip: trip)
    }
    
    /// Sets which trip should be selected to stand out from rest of trips.
    /// - Parameter index: Index of the trip to set
    public func SelectTrip(index: Int) {
        SetSelectedTrip(trip: tripLocations[index])
    }
    
    /// Set no trip to be selected.
    public func SelectTrip() {
        SetSelectedTrip(trip: nil)
    }
}
