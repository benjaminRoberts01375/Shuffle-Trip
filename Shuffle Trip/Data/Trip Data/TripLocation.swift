// Feb 12, 2022
// Ben Roberts

import MapKit
import SwiftUI
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Class defining where a trip takes place, as well as its details
public class TripLocation: ObservableObject, Identifiable {
    /// Location of the trip
    var coordinate: CLLocationCoordinate2D
    /// How far fro the location does teh trip span
    @Published var radius: Double {
        didSet {
            objectWillChange.send()
        }
    }
    /// Activities to be had at the trip
    var activityLocations: [Activity]
    /// User has selected this trip for editing/viewing
    @Published private(set) var isSelected: Bool {
        didSet {
            objectWillChange.send()
        }
    }
    /// Marks the trip as being visible with friends
    @Published public var isShared: Bool {
        didSet {
            objectWillChange.send()
        }
    }
    /// An unique identifier for each trip
    public let id: UUID
    /// ID for polygon
    var polyID: Int
    /// Name of the trip to be displayed to the user
    var name: String
    /// Status of the trip being downloaded
    var status: Status {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.radius = MapDetails.defaultRadius
        self.activityLocations = []
        self.isSelected = true
        self.isShared = false
        self.id = UUID()
        self.polyID = 0
        self.name = "Your New Trip"
        self.status = .unconfigured
    }
    
    func selectTrip(_ selected: Bool) {
        isSelected = selected
    }
    
    public enum Status {
        case unconfigured
        case generating
        case successful
        case error
    }
    
    private func generateActivities() {
        var params: [String] = ["Breakfast", "Lunch", "Dinner"]
        print("Params: \(params)")
        
        // Encode the TripRequest instance into JSON data
        status = .generating
        let tripRequest = TripRequest(terms: params, latitude: coordinate.latitude, longitude: coordinate.longitude, radius: Int(radius), count: Int(3))
        Task {
            do {
                self.activityLocations = try await APIHandler.request(url: .shuffleTrip, dataToSend: tripRequest, decodeType: [Activity].self)
                self.status = .successful
            }
            catch { self.status = .error }
        }
    }
    
    /// Function for regenerating trips
    /// - Parameter activityTypes: List of activities to go on
    public func ShuffleTrip() {
        generateActivities()
    }
}

extension TripLocation: Equatable {
    public static func == (lhs: TripLocation, rhs: TripLocation) -> Bool {
        return lhs.id == rhs.id
    }
}
