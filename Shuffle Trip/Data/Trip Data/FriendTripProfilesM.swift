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
    
    public static var shared: FriendTripProfiles = FriendTripProfiles()
    
    private init() {
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
    struct User: Decodable, Identifiable {
        let id: String
        let trips: [Trip]
        
        enum CodingKeys: String, CodingKey {
            case id = "userID"
            case trips
        }
    }

    struct Trip: Decodable, Identifiable {
        let name: String
        let rating: String
        let owner: String
        let description: String
        let activities: [Business]
        let latitude: Double
        let longitude: Double
        let radius: Int
        var id: UUID = UUID()
        
        enum CodingKeys: String, CodingKey {
            case name
            case rating
            case owner
            case description
            case activities
            case latitude
            case longitude
            case radius
        }
    }
    
    struct FriendTripRequest: Encodable {
        let userID: String
    }
    // swiftlint:enable nesting
}
