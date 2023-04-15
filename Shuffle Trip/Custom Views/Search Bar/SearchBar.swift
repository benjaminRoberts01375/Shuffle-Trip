// Jan 25, 2023
// Ben Roberts

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var placeholder = "Search..."
    var autoCorrection = false
    /// Creates the search bar when `SearchBar()` is called.
    /// - Parameter context: Automatically filled
    /// - Returns: The completed search bar
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = placeholder                         // Text when no user text is entered
        searchBar.searchBarStyle = .minimal                         // Typical search bar appearance
        searchBar.keyboardType = .asciiCapable                      // Show traditional keyboard minus emojis
        searchBar.autocorrectionType = autoCorrection ? .yes : .no  // Remove predictive text
        
        searchBar.delegate = context.coordinator                    // Assign coordinator
        
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: UIViewRepresentableContext<SearchBar>) { }
    
    /// Assigns coordinator for the SearchBar, allowing for communication with the search bar
    /// - Returns: A usable coordinator
    func makeCoordinator() -> SearchCoordinator {
        SearchCoordinator(search: $text)
    }
}
