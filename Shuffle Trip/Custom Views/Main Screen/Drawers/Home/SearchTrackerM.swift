// Apr 21, 2023
// Ben Roberts

import SwiftUI

final class SearchTrackerM: ObservableObject {
    /// What the user is searching for
    var searchText: String {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        self.searchText = ""
    }
}
