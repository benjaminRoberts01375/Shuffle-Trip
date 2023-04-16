// Apr 10, 2023
// Ben Roberts

import SwiftUI

struct TopicGroup: Decodable, Hashable {
    let name: String
    let symbol: String
    let color: Color
    let topics: [Topic]
    let id: UUID = UUID()
    
    public static func == (lhs: TopicGroup, rhs: TopicGroup) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Topic: Decodable, Equatable {
    let symbol: String
    let name: String
    let tags: [Tag]
    let id: UUID = UUID()

    enum CodingKeys: String, CodingKey {
        case symbol
        case name = "category"
        case tags = "data"
    }
}

class Tag: Decodable, Equatable {
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID = UUID()
    let name: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.name = try container.decode(String.self)
    }
}

extension Color: Decodable {
    public init(from decoder: Decoder) {
        do {
            let color = try decoder.singleValueContainer().decode(String.self)  // Decode JSON value to string
            self.init(UIColor(Color(color)))                                    // Convert string to Color, then to UIColor

        }
        catch {
            self.init(.clear)
        }
    }
}
