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
    public var fName: String?       
    public var mName: String?
    public var lName: String?
    public var email: String?
    
    enum CodingKeys: String, CodingKey {
        case userID
        case fName
        case mName
        case lName
        case email
    }
    
    private init() {
    }
}
