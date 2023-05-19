// April 22 2023
// Joseph Marchesini

import SwiftUI

public struct RequestResult: Decodable {
    let result: String

    enum CodingKeys: String, CodingKey {
        case result
    }
}

public struct RequestResultList: Decodable {
    let result: [String]

    enum CodingKeys: String, CodingKey {
        case result
    }
}
