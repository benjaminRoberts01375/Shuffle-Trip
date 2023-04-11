// Apr 11, 2023
// Ben Roberts

import SwiftUI

final class TermSelectionVM: ObservableObject {
    @Published private(set) var termGroups: [TermGroup]
    
    init() {
        self.termGroups = []
        loadData()
    }
    
    /// Loads term data from permanent storage into memory
    /// - Important: This should be run ASAP to avoid the user not noticing the terms being loaded.
    private func loadData() {
        guard let fileURL = Bundle.main.url(forResource: "Categories Grouped", withExtension: "json") else {    // Create URL to the Categories Group JSON file
            fatalError("Unable to find \"Categories Grouped.json\"")                                                // Not able to locate file
        }
        do {
            let data = try Data(contentsOf: fileURL)                                                            // Load data into memory
            self.termGroups = try JSONDecoder().decode([TermGroup].self, from: data)                            // Decode loaded data and store it
            
        } catch let error {                                                                                     // Catch-all for loading/decoding errors
            fatalError("Unable to parse categories JSON:\n\(error)")
        }
    }
}
