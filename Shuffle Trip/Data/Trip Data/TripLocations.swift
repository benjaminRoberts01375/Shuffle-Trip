// Jan 25, 2023
// Ben Roberts

import Combine
import MapKit
import SwiftUI

/// Object for keeping track of trip locations and their status
final class TripLocations: ObservableObject, Equatable {
    static func == (lhs: TripLocations, rhs: TripLocations) -> Bool {
        return lhs.tripLocations == rhs.tripLocations
    }
    
    /// List of all current trip locations
    @Published private(set) var tripLocations: [TripLocation] {
        didSet {
            self.objectWillChange.send()
        }
    }
    /// For dealing with observers
    private var cancellables: Set<AnyCancellable>
    
    /// Categories for trips as specified by the user
    var categories: [String] = []
    
    init(tripLocations: [TripLocation] = [], cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.tripLocations = tripLocations
        self.cancellables = cancellables
    }
    
    /// Standardized method of setting the selected trip
    /// - Parameter trip: Trip to set as selected
    private func SetSelectedTrip(trip: TripLocation?) {
        for tripLocation in tripLocations {
            tripLocation.selectTrip(tripLocation == trip)
        }
    }
    
    /// Adds a new trip location and selects it
    /// - Warning: Trips cannot have the same location, and duplicate locations will be discarded.
    /// - Parameter trip: Trip to add
    public func AddTrip(trip: TripLocation) {
        if !tripLocations.contains(where: { $0.coordinate == trip.coordinate }) {
            tripLocations.append(trip)
            SelectTrip(trip: trip)
            trip.objectWillChange.sink { _ in
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
            .store(in: &cancellables)
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
    
    /// Determins the selected trip if any are selected
    /// - Returns: The selected trip. Nil if no trip is found.
    public func getSelectedTrip() -> TripLocation? {
        return tripLocations.first(where: { $0.isSelected })
    }
}
