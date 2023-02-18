// Feb 12, 2022
// Ben Roberts

import MapKit
import SwiftUI

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
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.radius = MapDetails.defaultRadius
        self.activityLocations = []
        self.isSelected = true
        self.id = UUID()
        self.polyID = 0
        self.name = "Your New Trip"
        GenerateActivities()
    }
    
//    /// Something for the user to do during their trip
//    struct Activity {
//        /// Start date and time
//        let start: DateComponents
//        /// End date and time
//        let end: DateComponents
//        /// Where the activity is
//        let location: CLLocationCoordinate2D
//    }
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
        let rating: Int
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

    private func GenerateActivities() {
        if let fileUrl = Bundle.main.url(forResource: "Trip", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl)
                let decoder = JSONDecoder()
                activityLocations = try decoder.decode([Activities].self, from: data)
                print(activityLocations)
            } catch {
                print("Error reading JSON file: \(error)")
            }
        }
    }
}

extension TripLocation: Equatable {
    public static func == (lhs: TripLocation, rhs: TripLocation) -> Bool {
        return lhs.id == rhs.id
    }
}
