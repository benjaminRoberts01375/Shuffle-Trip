// Feb 12, 2022
// Ben Roberts

import Combine
import MapKit
import SwiftUI
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Class defining where a trip takes place, as well as its details
public class TripLocation: ObservableObject, Identifiable {
    /// Location of the trip
    var coordinate: CLLocationCoordinate2D
    /// How far fro the location does teh trip span
    @Published var radius: Double
    /// Activities to be had at the trip
    @Published private(set) var activityLocations: [Activity] {
        didSet {
            self.objectWillChange.send()
        }
    }
    /// User has selected this trip for editing/viewing
    @Published private(set) var isSelected: Bool
    /// An unique identifier for each trip
    public let id: UUID
    /// ID for polygon
    var polyID: Int
    /// Name of the trip to be displayed to the user
    var name: String
    /// Status of the trip being downloaded
    @Published var status: Status
    /// For dealing with observers
    private var cancellables: Set<AnyCancellable>
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.radius = MapDetails.defaultRadius
        self.activityLocations = []
        self.isSelected = true
        self.id = UUID()
        self.polyID = 0
        self.name = "Your New Trip"
        self.status = .unknown
        self.cancellables = []
    }
    
    func selectTrip(_ selected: Bool) {
        isSelected = selected
    }
    
    public enum Status {
        case unknown
        case generating
        case successful
        case error
    }
    
    /// Handles inserting an activity to the list of activities, as well as configuring the state changes
    /// - Parameters:
    ///   - activity: Activity to add
    ///   - index: Index to add it to
    public func insertActivity(activity: Activity, at index: Int = -1) {
        let insertIndex = index == -1 ? activityLocations.count : index
        activityLocations.insert(activity, at: insertIndex)
        activity.objectWillChange.sink { _ in
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
        .store(in: &cancellables)
    }
    
    /// Removes a specified activity from the trip
    /// - Parameter activity: Activity to remove
    public func removeActivity(activity: Activity) {
        activityLocations.removeAll(where: { $0.id == activity.id })
    }
    
    /// Generates activities based on user selection
    private func generateActivities() {
        let params: [[String]] = generateParamList()                                                                                                                // Generate parameters
        print("Params: \(params)")
        
        // Encode the TripRequest instance into JSON data
        status = .generating                                                                                                                                        // Mark the trip as being generated
        let tripRequest = TripRequest(
            terms: params,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            radius: Int(radius),
            count: params.count,
            userID: UserLoginM.shared.userID ?? "",
            chance: 0
        )      // Move details of request into TripRequest
        Task {                                                                                                                                                      // With async...
            do {                                                                                                                                                        // ...do...
                let newActivityLocations = try await APIHandler.request(url: .shuffleTrip, dataToSend: tripRequest, decodeType: [Activity].self)                        // ...Make the request for all activities
                print("New activities count: \(newActivityLocations.count), activities count: \(activityLocations.count)")
                if newActivityLocations.count == activityLocations.count {                                                                                              // Ensure the correct number of responses
                    for i in newActivityLocations.indices {                                                                                                                 // For each response
                        newActivityLocations[i].overwriteAllTags(oldActivity: activityLocations[i])                                                                             // Overwrite the previous activity
                    }
                    DispatchQueue.main.async {
                        self.activityLocations = newActivityLocations                                                                                                       // Save the activities
                        self.status = .successful                                                                                                                           // Mark trip as successfully generated
                    }
                }
                else {
                    self.status = .error                                                                                                                                // Otherwise there's an issu
                }
            }
        }
    }
    
    /// Function for regenerating trips
    /// - Parameter activityTypes: List of activities to go on
    public func ShuffleTrip() {
        generateActivities()
    }

    /// Shuffles a provided activity
    /// - Parameter oldActivity: Activity to shuffle
    public func shuffleActivity(activity oldActivity: Activity) {
        var params: [String] = oldActivity.tagIDs.map({ TagManager.shared.searchID(id: $0)?.name ?? "" })                                                               // Generate parameters from IDs
        params.removeAll(where: { $0 == "" })                                                                                                                           // Remove any unfound/invalid tags
        let activityRequest = TripRequest(
            terms: [params],
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            radius: Int(radius),
            count: params.count,
            userID: UserLoginM.shared.userID ?? "",
            chance: 0
        )    // Move details of request into TripRequest
        Task {                                                                                                                                                          // With async...
            do {                                                                                                                                                            // ...do...
                let newActivity = try await APIHandler.request(url: .shuffleTrip, dataToSend: activityRequest, decodeType: [Activity].self)                                     // ...Make the request for a new activity
                guard newActivity.count == 1,                                                                                                                                   // Make sure there's only one response
                      let activity = newActivity.first,                                                                                                                         // Get the first response
                      let index = activityLocations.firstIndex(of: oldActivity)                                                                                                 // Figure out where in the lineup of trips the activity is
                else { return }
                activity.overwriteAllTags(oldActivity: oldActivity)                                                                                                             // Save the old tags
                DispatchQueue.main.async {
                    self.removeActivity(activity: oldActivity)                                                                                                                  // Remove the placeholder activity
                    self.insertActivity(activity: activity, at: index)                                                                                                          // Add the new activity
                }
            }
        }
    }
    
    /// Generates the list of parameter names based on the trip location's activities
    /// - Returns: A list of lists. Each internal list represents an activity, while the individual items internally are tags the user's willing to do for that activity
    private func generateParamList() -> [[String]] {
        var params: [[String]] = []
        for activity in activityLocations {
            var tagNames: Set<String> = []
            for tagID in activity.tagIDs {
                guard let tagName = TagManager.shared.searchID(id: tagID)?.name else { continue }
                tagNames.insert(tagName)
            }
            params.append(Array(tagNames))
        }
        return params
    }
}

extension TripLocation: Equatable {
    public static func == (lhs: TripLocation, rhs: TripLocation) -> Bool {
        return lhs.id == rhs.id
    }
}

/// Struct for handling the required params for requesting trip activities
struct TripRequest: Encodable {
    let terms: [[String]]
    let latitude: Double
    let longitude: Double
    let radius: Int
    let count: Int
    let userID: String
    let chance: Int
}

struct SaveTrip: Encodable {
    let rating: Float
    let owner: String
    let name: String
    let description: String
    let tripID: String
    let latitude: Double
    let longitude: Double
    let radius: Double
    let activities: [String]
    let ratings: [Float]
}

struct DeleteTrip: Encodable {
    let tripID: String
}
