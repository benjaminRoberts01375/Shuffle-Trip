// Apr 10, 2023
// Ben Roberts

import SwiftUI

struct TermGroup: Decodable {
    let name: String
    let symbol: String
    let color: Color
    let topics: [Topic]
}

struct Topic: Decodable {
    let symbol: String
    let name: String
    let categories: [String]

    enum CodingKeys: String, CodingKey {
        case symbol
        case name = "category"
        case categories = "data"
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
