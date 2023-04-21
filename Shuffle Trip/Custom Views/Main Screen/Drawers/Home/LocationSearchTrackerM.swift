// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class LocationSearchTrackerM: ObservableObject {
    /// What the user is searching for
    var searchText: String {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        self.searchText = ""
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
                print("Search error")
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
            
            print("Responses: \(response.mapItems)")
            
        }
    }
}
