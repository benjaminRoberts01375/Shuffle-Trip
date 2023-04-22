// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class LocationSearchTrackerM: ObservableObject {
    /// What the user is searching for
    @Published public var searchText: String
    
    /// All MKMapItems from the latest search result
    @Published public private(set) var searchResults: [MKMapItem] {
        didSet {
            print("Set results")
            self.objectWillChange.send()
        }
    }
    
    /// Keep track of time since last search
    private var searchTimer: Timer?
    
    init() {
        self.searchText = ""
        self.searchResults = []
    }
    
    /// Searches for locations based on natural language
    internal func searchLocation(_ location: String) {
        searchTimer?.invalidate() // cancel any previously scheduled search
            
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [weak self] _ in    // Rate limit function call to every 0.1 seconds
            guard let self = self else { return }
            let request = MKLocalSearch.Request()
            request.pointOfInterestFilter = MapDetails.defaultFilter
            request.naturalLanguageQuery = self.searchText
            
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                if error != nil {
                    guard let error = error else { return }
                    print("Search error: \(error)")
                    return
                }
                guard let response = response
                else {
                    print("Response error")
                    return
                }
                
                if response.mapItems.isEmpty {
                    print("No items")
                    return
                }
                self.searchResults = response.mapItems
                if !self.searchResults.isEmpty {
                    print("\(self.searchText): \(self.searchResults.count) - \(self.searchResults[0].name ?? "")")
                    self.objectWillChange.send()
                    // subThoroghfare = house num
                    // thoroughfare = street
                    // locality = city
                    // administrativeArea = state
                    // isoCountryCode = country code
                }
            }
        }
    }
}
