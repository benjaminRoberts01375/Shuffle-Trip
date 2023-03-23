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
    var radius: CGFloat
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
    /// Categories to shuffle from
    @ObservedObject var categories: CategoryDataM
    /// Status of the trip being downloaded
    var status: Status {
        didSet {
            objectWillChange.send()
        }
    }
    
    init(coordinate: CLLocationCoordinate2D, categories: CategoryDataM) {
        self.coordinate = coordinate
        self.radius = MapDetails.defaultRadius
        self.activityLocations = []
        self.isSelected = true
        self.isShared = false
        self.id = UUID()
        self.polyID = 0
        self.name = "Your New Trip"
        self._categories = ObservedObject(initialValue: categories)
        self.status = .generating
        generateActivities()
    }
    
    func selectTrip(_ selected: Bool) {
        isSelected = selected
    }
    
    public enum Status {
        case generating
        case successful
        case error
    }
    
    private func generateActivities() {
        var params: [String] = []
        for topic in categories.topics {
            for category in topic.selected {
                params.append(category)
            }
        }
        
        print("Params: \(params)")
        
        // Encode the TripRequest instance into JSON data
        status = .generating
        let tripRequest = TripRequest(terms: params, latitude: coordinate.latitude, longitude: coordinate.longitude, radius: Int(radius), count: Int(3))
        guard let jsonData = try? JSONEncoder().encode(tripRequest) else {
            print("Error encoding TripRequest")
            return
        }
        
        // Create a URLRequest with the URL, HTTP method, and HTTP headers for the POST request
        guard let url = URL(string: "https://shuffle-trip-backend.herokuapp.com/filteredApi") else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Send the POST request using URLSession
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                let nsError = error as NSError
                if nsError.code == NSURLErrorCannotConnectToHost {
                    print("Error: cannot connect to host")
                    self.status = .error
                    return
                } else {
                    print("Error sending POST request: \(error)")
                    self.status = .error
                    return
                }
            }

            guard let data = data else {
                print("Error: empty response")
                self.status = .error
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let activities = try decoder.decode([Activity].self, from: data)
                self.activityLocations = activities
                self.status = .successful
            } catch {
                print("Error decoding response data: \(error)")
                self.status = .error
            }
        }
        task.resume()
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
