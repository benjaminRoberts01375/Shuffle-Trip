// Jan 25, 2023
// Ben Roberts

import SwiftUI

class SearchCoordinator: NSObject, UISearchBarDelegate {
    @Binding var userIsSearching: Bool
    
    init(userIsSearching: Binding<Bool>) {
        self._userIsSearching = userIsSearching
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        userIsSearching = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        userIsSearching = false
        searchBar.endEditing(true)
    }
}
