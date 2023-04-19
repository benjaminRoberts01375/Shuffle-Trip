// April 18 2023
// Joseph Marchesini

import SwiftUI

final class UserLoginM: Codable, ObservableObject {
    
    public static var shared: UserLoginM = UserLoginM()
    
    public var userID: String? {
        didSet {
            self.objectWillChange.send()
        }
    }
    public var email: String?
    public var name: String?
    public var interests: [String]?
    public var preferences: [String]?
    
    enum CodingKeys: String, CodingKey {
        case userID
        case email
        case name
        case interests
        case preferences
    }
    
    private init() {
    }
}
