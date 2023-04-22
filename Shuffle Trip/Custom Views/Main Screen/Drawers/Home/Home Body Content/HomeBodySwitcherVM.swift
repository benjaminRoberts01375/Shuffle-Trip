// Apr 21, 2023
// Ben Roberts

import CodeScanner
import MapKit
import SwiftUI

final class HomeBodySwitcherVM: ObservableObject {
    /// All user locations for the current user
    var tripLocations: TripLocations
    /// Tracker for what the user is searching for
    var searchTracker: LocationSearchTrackerM
    /// Determines content to display to the user
    @Published var displayPhase: DisplayPhase
    @Published var scanQRCode: Bool
    @Published var presentQRCode: Bool
    
    init(tripLocations: TripLocations, searchTracker: LocationSearchTrackerM) {
        self.tripLocations = tripLocations
        self.searchTracker = searchTracker
        self.displayPhase = .normal
        self.scanQRCode = false
        self.presentQRCode = false
    }
    
    enum DisplayPhase {
        case normal
        case tripSearch
        case presentQRCode
        case readQRCode
    }
    
    func setDisplayPhase() {
        let newPhase = searchTracker.searchText.isEmpty ? DisplayPhase.normal : DisplayPhase.tripSearch
        if displayPhase != newPhase {
            displayPhase = newPhase
        }
    }
    
    /// Adds a trip based on the location of an MKMapItem
    /// - Parameter trip: Trip location to add as an MKMapItem
    internal func addTrip(trip: MKMapItem) {
        tripLocations.AddTrip(trip: TripLocation(coordinate: trip.placemark.coordinate))
    }
    
    /// Handles the result of scanning a QR code
    /// - Parameter result: The result from the Code Scanner
    internal func scan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let friendCode = result.string
            Task {
                do {
                    _ = try await APIHandler.request(url: .addFriend, dataToSend: MakeFriend(sender: friendCode, receiver: UserLoginM.shared.userID ?? ""), decodeType: String.self)
                }
            }
            displayPhase = .normal
        case .failure(let error):
            print("Unable to read QR code. \(error)")
        }
    }
}

struct MakeFriend: Codable {
    let sender: String
    let receiver: String
    
    enum CodingKeys: String, CodingKey {
        case sender = "user1"
        case receiver = "user2"
    }
}
