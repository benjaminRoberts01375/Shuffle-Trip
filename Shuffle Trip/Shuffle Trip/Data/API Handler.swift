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
    
}
