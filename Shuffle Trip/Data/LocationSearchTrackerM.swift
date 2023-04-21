// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class LocationSearchTrackerM: ObservableObject {
    /// What the user is searching for
    @Published public var searchText: String
    
    /// All MKMapItems from the latest search result
    public private(set) var searchResults: [MKMapItem] {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        self.searchText = ""
        self.searchResults = []
    }
    
    /// Searches for locations based on natural language
    internal func searchLocation() {
        print("Searching \(searchText)")
        let request = MKLocalSearch.Request()
        request.pointOfInterestFilter = MapDetails.defaultFilter
        request.naturalLanguageQuery = searchText
        
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
            print(response.mapItems)
            self.searchResults = response.mapItems
        }
    }
}
