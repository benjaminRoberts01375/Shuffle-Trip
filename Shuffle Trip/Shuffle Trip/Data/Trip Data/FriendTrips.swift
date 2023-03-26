// Mar 23, 2023
// Ben Roberts

import SwiftUI

final class FriendTripProfiles: ObservableObject {
    let myUsername: String
    @Published var status: Status
    @Published var friends: [User]
    
    init() {
        self.myUsername = "Drew"
        self.status = .generating
        self.friends = []
        GenerateFriends()
    }
    
    /// Generates a list of friends
    private func GenerateFriends() {
        // Encode FriendTripRequest instance into JSON data
        status = .generating
        let tripRequest = FriendTripRequest(username: myUsername)
        guard let jsonData = try? JSONEncoder().encode(tripRequest) else {
            print("Error encoding FriendTripRequest")
            return
        }
        
        // Create a URLRequest with the URL, HTTP method, and HTTP headers for the POST request
        guard let url = URL(string: "https://shuffle-trip-backend.herokuapp.com/getFriendsTrips") else {
            print("Error: cannot create URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Send the POST request using URLSession
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            if let error = error {
                let nsError = error as NSError
                if nsError.code == NSURLErrorCannotConnectToHost {
                    print("Error: cannot connect to host")
                    self.status = .error
                    return
                } else {
                    print("Error sending POST request: \(error)")
                    self.status = .error
                    return
                }
            }
            
            guard let data = data else {
                print("Error: empty response")
                self.status = .error
                return
            }
            
            print(String(decoding: data, as: UTF8.self))
            
            do {
                let decoder = JSONDecoder()
                let friends = try decoder.decode([User].self, from: data)
                self.friends = friends
                self.status = .successful
            } catch {
                print("Error decoding response data: \(error)")
                self.status = .error
            }
        }
        task.resume()
    }
    
    enum Status {
        case generating
        case error
        case successful
    }

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
}
