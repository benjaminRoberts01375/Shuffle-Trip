// Jan 25, 2023
// Ben Roberts

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @State var text: String = ""
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar: UISearchBar = UISearchBar()
        searchBar.placeholder = "Find your next day trip..."
        searchBar.searchBarStyle = .minimal
        searchBar.keyboardType = .asciiCapable
        searchBar.autocorrectionType = .no
        
        
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        print("Search update")
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
