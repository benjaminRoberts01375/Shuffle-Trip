// Feb 12, 2022
// Ben Roberts

import MapKit
import SwiftUI
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Class defining where a trip takes place, as well as its details
public class TripLocation {
    /// Location of the trip
    var coordinate: CLLocationCoordinate2D
    /// How far fro the location does teh trip span
    var radius: CGFloat
    /// Activities to be had at the trip
    var activityLocations: [Activities]
    /// User has selected this trip for editing/viewing
    var isSelected: Bool
    /// An unique identifier for each trip
    let id: UUID
    /// ID for polygon
    var polyID: Int
    /// Name of the trip to be displayed to the user
    var name: String
    /// Categories to shuffle from
    var categories: [String]
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.radius = MapDetails.defaultRadius
        self.activityLocations = []
        self.isSelected = true
        self.id = UUID()
        self.polyID = 0
        self.name = "Your New Trip"
        self.categories = ["Breakfast", "Lunch", "Dinner", "Education", "Automotive", "Arts", "Active", "Active"]
        generateActivities(params: self.categories)
    }
    
    // swiftlint:disable nesting
    struct Activities: Decodable, Hashable {
        static func == (lhs: TripLocation.Activities, rhs: TripLocation.Activities) -> Bool {
            return lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        let businesses: [Business]
        let total: Int
        let region: Region
        let id = UUID()
        
        enum CodingKeys: String, CodingKey {
            case businesses
            case total
            case region
        }
    }
    
    struct Business: Decodable {
        let id: String
        let alias: String
        let name: String
        let imageUrl: String
        let isClosed: Bool
        let url: String
        let reviewCount: Int
        let categories: [Category]
        let rating: Double
        let coordinates: Coordinates
        let transactions: [String]
        let location: Location
        let phone: String
        let displayPhone: String
        let distance: Double
        
        enum CodingKeys: String, CodingKey {
            case id
            case alias
            case name
            case imageUrl = "image_url"
            case isClosed = "is_closed"
            case url
            case reviewCount = "review_count"
            case categories
            case rating
            case coordinates
            case transactions
            case location
            case phone
            case displayPhone = "display_phone"
            case distance
        }
    }
    
    struct Category: Decodable {
        let alias: String
        let title: String
    }
    
    struct Coordinates: Decodable {
        let latitude: Double
        let longitude: Double
    }
    
    struct Location: Decodable {
        let address1: String
        let address2: String?
        let address3: String?
        let city: String
        let zipCode: String
        let country: String
        let state: String
        let displayAddress: [String]
        
        enum CodingKeys: String, CodingKey {
            case address1
            case address2
            case address3
            case city
            case zipCode = "zip_code"
            case country
            case state
            case displayAddress = "display_address"
        }
    }
    // swiftlint:enable nesting
    
    struct Region: Decodable {
        let center: Center
    }
    
    struct Center: Decodable {
        let longitude: Double
        let latitude: Double
    }
    
    struct TripRequest: Encodable {
        let terms: [String]
        let latitude: Double
        let longitude: Double
        let radius: Int
    }
    
    private func generateActivities(params: [String]) {
        // Encode the TripRequest instance into JSON data
        let tripRequest = TripRequest(terms: params, latitude: coordinate.latitude, longitude: coordinate.longitude, radius: Int(radius))
        guard let jsonData = try? JSONEncoder().encode(tripRequest) else {
            print("Error encoding TripRequest")
            return
        }
        
        // Create a URLRequest with the URL, HTTP method, and HTTP headers for the POST request
        guard let url = URL(string: "http://localhost:9000/api") else {
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
                    return
                } else {
                    print("Error sending POST request: \(error)")
                    return
                }
            }

            guard let data = data else {
                print("Error: empty response")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let activities = try decoder.decode([Activities].self, from: data)
                self.activityLocations = activities
            } catch {
                print("Error decoding response data: \(error)")
            }
        }
        task.resume()
    }
    
    /// Function for regenerating trips
    /// - Parameter activityTypes: List of activities to go on
    public func ShuffleTrip() {
        generateActivities(params: categories)
    }
}

extension TripLocation: Equatable {
    public static func == (lhs: TripLocation, rhs: TripLocation) -> Bool {
        return lhs.id == rhs.id
    }
}
