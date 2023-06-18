// Mar 27, 2023
// Ben Roberts

import SwiftUI

struct APIHandler {
    struct APIConfig: Decodable {
        let baseURL: String
        let APIUrls: [String: String]
    }
    
    // swiftlint:disable redundant_string_enum_value
    // Disabled as a quick hack to allow for another hack for API calls (we're moving real quick here)
    enum APIUrl: String {
        case shuffleTrip = "shuffleTrip"
        case friendDetails = "friendDetails"
        case sendUserData = "sendUserData"
        case getUserData = "getUserData"
        case requestActivity = "requestActivity"
        case saveTrip = "saveTrip"
        case deleteTrip = "deleteTrip"
        case addFriend = "addFriend"
    }
    // swiftlint:enable redundant_string_enum_value
    
    enum Errors: String, Error {
        /// Unable to decode data from the server.
        case decodeError = "Unable to decode data from the server."
        /// Got no data back from the server.
        case emptyResponse = "Got no data back from the server."
        /// Unable to encode data into a request.
        case encodeError = "Unable to encode data into a request."
        /// Unable to connect to the server.
        case hostConnectionError = "Unable to connect to the server."
        /// Unknown error.
        case sendPOSTError = "Unknown error."
        /// Not able to generate server URL.
        case urlError = "Not able to generate server URL."
        static let configLoadError = "Unable to load API configuration."
    }
    
    private static let config: APIConfig = {
        guard let fileURL = Bundle.main.url(forResource: "URLs", withExtension: "json") else {
            fatalError("Missing 'apiConfig.json' file.")
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(APIConfig.self, from: data)
        } catch {
            fatalError("Error loading API configuration: \(error)")
        }
    }()
    
    static let baseURL: String = config.baseURL
    
    static func request<D: Decodable, E: Encodable>(url addition: APIUrl, dataToSend: E, decodeType: D.Type) async throws -> D {
        guard let apiUrl = config.APIUrls[addition.rawValue] else {
            throw Errors.urlError
        }
        guard let requestUrl = URL(string: baseURL + apiUrl) else {
            throw Errors.urlError
        }
        
        guard let jsonData = try? JSONEncoder().encode(dataToSend) else {
            throw Errors.encodeError
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        print(String(decoding: jsonData, as: UTF8.self))
        
        let (data, response) = try await URLSession.shared.data(for: request)                           // Send JSON and wait for response
        
        print(String(decoding: data, as: UTF8.self))
        
        guard let httpResponse = response as? HTTPURLResponse else {                                    // Check against HTTP error
            print("Host connection error")
            throw Errors.hostConnectionError
        }
        guard (200...299).contains(httpResponse.statusCode) else {                                      // Check status code
            print("POST error")
            throw Errors.sendPOSTError
        }
        guard !data.isEmpty else {                                                                      // Check data response
            print("Empty response")
            throw Errors.emptyResponse
        }
        
        guard let decodedData = try? JSONDecoder().decode(decodeType, from: data) else {                // All is good, decode data if possible
            print("Decode error")
            throw Errors.decodeError
        }
        
        return decodedData                                                                              // Return decoded data
    }
}
