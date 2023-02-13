// Jan 25, 2023
// Ben Roberts

import SwiftUI
import MapKit

/// Object for keeping track of trip locations and their status
final class TripLocations: ObservableObject {
    /// List of specified trip locations
    var tripLocations: [TripLocation] = []  {
        didSet {
            for action in todoList {
                action()
            }
        }
    }
    
    /// List of closures to execute when the list of trips or activities are updated.
    private var todoList: [() -> Void] = []
    
    /// Add code to be called when the trip locations are updated. This can happenw when any of the available variables change.
    /// - Parameter action: Closure that is called when trip locations are added.
    public func AddTripLocationAcion(action: @escaping () -> Void) {
        todoList.append(action)
    }
}
