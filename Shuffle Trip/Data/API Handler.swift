// Mar 27, 2023
// Ben Roberts

import SwiftUI

struct APIHandler {
    static let baseURL: String = "https://shuffle-trip-backend.herokuapp.com/"
    
    enum APIUrl: String {
        case shuffleTrip = "filteredApi"
        case friendDetauls = "getFriendsTrips"
        case sendUserData = "user"
        case getUserData = "getUser"
    }
    
    /// Errors available to throw
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
    }
    
    /// A one-stop-shop for sending and receiving JSON data from the backend
    /// - Parameters:
    ///   - url: Request being made.
    ///   - dataToSend: Data to send to the server
    ///   - decodeType: Type of data that the responding JSON should be decoded into
    /// - Returns: The decoded data
    /// - Throws: An error from the errors enum that is a part of this struct
    static func request<D: Decodable, E: Encodable>(url addition: APIUrl, dataToSend: E, decodeType: D.Type) async throws -> D {
        guard let requestUrl = URL(string: baseURL + addition.rawValue) else { throw Errors.urlError }  // Build URL to send POST request to
        guard let jsonData = try? JSONEncoder().encode(dataToSend) else { throw Errors.encodeError }    // Encode JSON
        
        var request = URLRequest(url: requestUrl)                                                       // Create request
        request.httpMethod = "POST"                                                                     // Set request to POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")                        // Add request header
        request.httpBody = jsonData                                                                     // Add JSON to request
        
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
