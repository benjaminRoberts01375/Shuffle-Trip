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

struct Category: Decodable, Hashable {
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
