// April 18 2023
// Joseph Marchesini

import SwiftUI

final class UserLoginM: ObservableObject {
    
    public static var shared: UserLoginM = UserLoginM()
    
    @Published public var userID: String? {
        didSet {
            self.objectWillChange.send()
        }
    }
    public var fName: String?
    public var mName: String?
    public var lName: String?
    public var email: String?
    
    private init() {
    }
}
