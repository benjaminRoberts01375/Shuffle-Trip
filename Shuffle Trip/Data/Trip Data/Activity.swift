// Mar 20, 2023
// Ben Roberts

import SwiftUI

public class Activity: Decodable, Hashable, ObservableObject {
    
    /// Allows for comparing two Activities
    /// - Parameters:
    ///   - lhs: Activity on the left hand side of double equals
    ///   - rhs: Activity on the right hand side of double equals
    /// - Returns: If the two are the same Activity
    public static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var businesses: [Business]?
    var total: Int?
    var region: Region?
    /// Unique ID of the activity
    let id = UUID()
    /// Tags that determine what can go into this trip
    @Published private(set) var tagIDs: Set<UUID> = [] {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case businesses
        case total
        case region
    }
    
    /// Handles adding tags to the activity
    /// - Parameter tagID: ID of the tag to add
    public func addTag(tagID: UUID) {
        tagIDs.insert(tagID)
    }
    
    
    /// Checks the name of a tag before adding it to the activity
    /// - Parameter tagName: Name of the tag to add
    /// - Returns: A boolean for if the tag was able to be added to the activity's trip ids
    public func addTag(tagName: String) -> Bool {
        guard let tagID = TagManager.shared.tagNameToID(tagName: tagName) else { return false }
        addTag(tagID: tagID)
        return true
    }
    
    /// Handles removing tags from the activity
    /// - Parameter tagID: ID of the tag to remove
    public func removeTag(tagID: UUID) {
        tagIDs.remove(tagID)
    }
    
    /// Checks to see if every tag is selected within a topic
    /// - Parameter topic: Topic to check for
    /// - Returns: Bool of if every tag is selected
    public func topicIsSelected(topic: Topic) -> Bool {
        return topic.tags.allSatisfy { tag in
            tagIDs.contains(tag.id)
        }
    }
    
    /// Adds every tag from a topic
    /// - Parameter topic: Topic to add
    public func selectTopic(topic: Topic) {
        var idCache: Set<UUID> = tagIDs
        for tag in topic.tags {
            idCache.insert(tag.id)
        }
        tagIDs = idCache
    }
    
    /// Removes every tag from a topic
    /// - Parameter topic: Topic to remove
    public func deselectTopic(topic: Topic) {
        var idCache: Set<UUID> = tagIDs
        for tag in topic.tags {
            idCache.remove(tag.id)
        }
        tagIDs = idCache
    }
    
    /// Overwrites the tag of this activity with another activity's tags
    /// - Parameter oldActivity: Activity to copy tags from
    public func overwriteAllTags(oldActivity: Activity) {
        tagIDs = oldActivity.tagIDs
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

/// Struct for handling the required params for requesting a specific activity
struct ActivityRequest: Encodable {
    /// Name of the business
    let name: String
    /// Ex. 123 Summit ln
    let address: String
    /// Town or city
    let city: String
    /// State
    let state: String
    /// Country
    let country: String
}

// swiftlint:enable discouraged_optional_boolean
