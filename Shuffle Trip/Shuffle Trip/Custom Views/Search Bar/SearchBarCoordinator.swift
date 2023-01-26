// Jan 25, 2023
// Ben Roberts

import SwiftUI

class SearchCoordinator: NSObject, UISearchBarDelegate {
    var parent: SearchBar
    
    init(_ parent: SearchBar) {
        self.parent = parent
    }
}
