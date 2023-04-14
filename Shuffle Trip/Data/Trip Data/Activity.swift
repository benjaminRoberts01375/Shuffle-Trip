// Mar 20, 2023
// Ben Roberts

import SwiftUI

public struct Activity: Decodable, Hashable {
    public static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let businesses: [Business]
    let total: Int
    let region: Region
    let id = UUID()
    var tagIDs: [UUID] = []
    
    enum CodingKeys: String, CodingKey {
        case businesses
        case total
        case region
    }
}

// swiftlint:disable discouraged_optional_boolean
struct Business: Decodable {
    let alias: String
    let categories: [Category]
    let coordinates: Coordinates
    let displayPhone: String
    let distance: Double?
    let hours: [Hour]?
    let id: String
    let imageUrl: String
    let isClaimed: Bool?
    let isClosed: Bool
    let location: Location
    let messaging: Messaging?
    let name: String
    let phone: String
    let price: String?
    let photos: [String]?
    let rating: Double
    let reviewCount: Int
    let transactions: [String]
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case alias
        case categories
        case coordinates
        case displayPhone = "display_phone"
        case distance
        case hours
        case id
        case imageUrl = "image_url"
        case isClaimed = "is_claimed"
        case isClosed = "is_closed"
        case location
        case messaging
        case name
        case phone
        case photos
        case price
        case rating
        case reviewCount = "review_count"
        case transactions
        case url
    }
}

struct Category: Decodable, Hashable {
    let alias: String
    let title: String
}

struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}

struct Location: Decodable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let country: String?
    let crossStreets: String?
    let displayAddress: [String]
    let state: String?
    let zipCode: String?
    
    enum CodingKeys: String, CodingKey {
        case address1
        case address2
        case address3
        case city
        case country
        case crossStreets = "cross_streets"
        case displayAddress = "display_address"
        case state
        case zipCode = "zip_code"
    }
}

struct Region: Decodable {
    let center: Center
}

struct Center: Decodable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

struct Hour: Codable {
    let isOpenNow: Bool
    let hoursType: String
    let open: [Open]
    
    enum CodingKeys: String, CodingKey {
        case isOpenNow = "is_open_now"
        case hoursType = "hours_type"
        case open
    }
}

struct Open: Codable {
    let end: String
    let day: Int
    let isOvernight: Bool
    let start: String
    
    enum CodingKeys: String, CodingKey {
        case end
        case day
        case isOvernight = "is_overnight"
        case start
    }
}

struct Messaging: Codable {
    let useCaseText: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case useCaseText = "use_case_text"
        case url
    }
}

struct TripRequest: Encodable {
    let terms: [String]
    let latitude: Double
    let longitude: Double
    let radius: Int
    let count: Int
}
