// Mar 27, 2023
// Ben Roberts

import SwiftUI

struct APIHandler {
    static let baseURL: String = "https://shuffle-trip-backend.herokuapp.com/"
    
    enum APIUrl: String {
        case shuffleTrip = "filteredApi"
        case friendDetauls = "getFriendsTrips"
    }
    
    enum Errors: String, Error {
        case decodeError = "Unable to decode data from the server."
        case emptyResponse = "Got no data back from the server."
        case encodeError = "Unable to encode data into a request."
        case hostConnectionError = "Unable to connect to the server."
        case sendPOSTError = "Unknown error."
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
        guard let requestUrl = URL(string: baseURL + addition.rawValue) else { throw Errors.urlError }
        guard let jsonData = try? JSONEncoder().encode(dataToSend) else { throw Errors.encodeError }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else { throw Errors.hostConnectionError }
        guard (200...299).contains(httpResponse.statusCode) else { throw Errors.sendPOSTError }
        guard !data.isEmpty else { throw Errors.emptyResponse }
        
        // Decode the response data
        guard let decodedData = try? JSONDecoder().decode(decodeType, from: data) else { throw Errors.decodeError }
        
        return decodedData
    }
}
