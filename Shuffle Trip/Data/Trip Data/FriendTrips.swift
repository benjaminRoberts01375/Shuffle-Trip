// Mar 23, 2023
// Ben Roberts

import SwiftUI

final class FriendTripProfiles: ObservableObject {
    let myUsername: String
    @Published var status: Status
    @Published var friends: [User]
    
    init() {
        self.myUsername = UserLoginM.shared.userID ?? ""
        self.status = .generating
        self.friends = []
        GenerateFriends()
    }
    
    /// Generates a list of friends
    private func GenerateFriends() {
        // Encode FriendTripRequest instance into JSON data
        status = .generating
        let tripRequest = FriendTripRequest(username: myUsername)
        Task {
            do {
                self.friends = try await APIHandler.request(url: .friendDetauls, dataToSend: tripRequest, decodeType: [User].self)
                self.status = .successful
            }
            catch { self.status = .error }
        }
    }
    
    enum Status {
        case generating
        case error
        case successful
    }

    // swiftlint:disable nesting
    struct User: Decodable {
        let username: String
        let trips: [Trip]
        
        enum CodingKeys: String, CodingKey {
            case username
            case trips
        }
    }

    struct Trip: Decodable {
        let name: String
        let rating: String
        let owner: String
        let description: String
        let activities: [Business]
        
        enum CodingKeys: String, CodingKey {
            case name
            case rating
            case owner
            case description
            case activities
        }
    }
    
    struct FriendTripRequest: Encodable {
        let username: String
    }
    // swiftlint:enable nesting
}
