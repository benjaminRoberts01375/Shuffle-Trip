// Jan 25, 2023
// Ben Roberts

import SwiftUI

class SearchCoordinator: NSObject, UISearchBarDelegate {
    @ObservedObject var userIsSearching: SearchTracker { didSet {print("Is full changed in Search Coordinator")}}
    
    init(userIsSearching: SearchTracker) {
        self.userIsSearching = userIsSearching
    }
    
    /**
     Ensure that the text currently saved by program is displayed to user to keep consistency
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
    }
    
    /**
     Search bar was tapped on
     */
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)    // User tapped on search bar, so show the cancel button
        userIsSearching.isFull = true                           // Update parent view(s)
    }
    
    /**
     User hit the cancel button, so reset the search bar
     */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""                                     // Clear displayed text
        searchBar.setShowsCancelButton(false, animated: true)   // Hide the cancel button with an animation
        userIsSearching.isFull = false                          // Update parent view(s)
        searchBar.endEditing(true)                              // Not sure if actually needed, just in case of weird future changes
    }
}
