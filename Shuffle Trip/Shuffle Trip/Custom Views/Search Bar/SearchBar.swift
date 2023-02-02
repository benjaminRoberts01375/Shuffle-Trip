// Jan 25, 2023
// Ben Roberts

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @ObservedObject var userIsSearching: SearchTracker
    
    
    /// Creates the search bar when ```SearchBar()``` is called.
    /// - Parameter context: Automatically filled
    /// - Returns: The completed search bar
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Find your next day trip..."    // Text when no user text is entered
        searchBar.searchBarStyle = .minimal                     // Typical search bar appearance
        searchBar.keyboardType = .asciiCapable                  // Show traditional keyboard minus emojis
        searchBar.autocorrectionType = .no                      // Remove predictive text
        
        searchBar.delegate = context.coordinator                // Assugn coordinator
        
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: UIViewRepresentableContext<SearchBar>) { }
    
    
    /// Assigns coordinator for the SearchBar, allowing for communication with the search bar
    /// - Returns: A usable coordinator
    func makeCoordinator() -> SearchCoordinator {
        SearchCoordinator(userIsSearching: userIsSearching)
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(userIsSearching: SearchTracker())
    }
}
