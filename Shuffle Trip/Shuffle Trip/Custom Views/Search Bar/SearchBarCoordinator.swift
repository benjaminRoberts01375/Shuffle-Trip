// Jan 25, 2023
// Ben Roberts

import SwiftUI

/// Coordinator for the Search Bar
class SearchCoordinator: NSObject, UISearchBarDelegate {
    /// Called every time the user types into the search bar
    /// - Parameters:
    ///   - searchBar: The search bar being updated
    ///   - searchText: The text that the search bar is storing internally
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
    }
    
    /// Called when the search bar is tapped on
    /// - Parameter searchBar: Search bar that was tapped on
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)    // User tapped on search bar, so show the cancel button
    }
    
    /// Called when the user presses on the search bar's cancel button
    /// - Parameter searchBar: Search bar the was tapped on
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""                                     // Clear displayed text
        searchBar.setShowsCancelButton(false, animated: true)   // Hide the cancel button with an animation
        searchBar.endEditing(true)                              // Not sure if actually needed, just in case of weird future changes
    }
}
