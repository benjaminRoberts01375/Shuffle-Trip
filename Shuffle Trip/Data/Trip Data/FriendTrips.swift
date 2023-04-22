// Mar 23, 2023
// Ben Roberts

import SwiftUI

final class FriendTripProfiles: ObservableObject {
    @Published var status: Status {
        didSet {
            self.objectWillChange.send()
        }
    }
    @Published var friends: [User]
    
    init() {
        self.status = .uninit
        self.friends = []
    }
    
    /// Generates a list of friends
    public func GenerateFriends() {
        // Encode FriendTripRequest instance into JSON data
        status = .generating
        let tripRequest = FriendTripRequest(userID: UserLoginM.shared.userID ?? "")
        Task {
            do {
                let newFriends = try await APIHandler.request(url: .friendDetails, dataToSend: tripRequest, decodeType: [User].self)
                DispatchQueue.main.async {
                    self.friends = newFriends
                    self.status = .successful
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.status = .error
                }
            }
        }
    }
    
    enum Status {
        case uninit
        case generating
        case error
        case successful
    }

    // swiftlint:disable nesting
    struct User: Decodable {
        let userID: String
        let trips: [Trip]
        
        enum CodingKeys: String, CodingKey {
            case userID
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
        let userID: String
    }
    // swiftlint:enable nesting
}
