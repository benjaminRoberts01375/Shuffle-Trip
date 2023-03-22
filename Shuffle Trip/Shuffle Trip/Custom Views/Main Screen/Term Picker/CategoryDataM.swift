// Mar 22, 2023
// Ben Roberts

import Foundation
import SwiftUI

final class CategoryDataM: ObservableObject {
    /// A list of all categories available to Shuffle Trip
    @Published var categories: [Category]
    
    init() {
        self.categories = []
        LoadData()
    }
    
    public struct Category: Codable {
        let symbol: String
        let data: [String]
        let category: String
    }
    
    /// Load category data into memory
    private func LoadData() {
        // Load the JSON file
        guard let fileURL = Bundle.main.url(forResource: "Categories", withExtension: "json") else {    // Name of the categories file
            fatalError("Unable to find Categories.json")
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            self.categories = try decoder.decode([Category].self, from: data)
            print(categories.count)
            for category in categories {
                print(category.category)
            }
        } catch {
            fatalError("Unable to parse data.json: \(error)")
        }
        
        do {
            let data = try Data(contentsOf: fileURL)                        // Raw JSON data
            let decoder = JSONDecoder()                                     // Decoder for JSON to structs
            categories = try decoder.decode([Category].self, from: data)    // Decode JSON to structs
        }
        catch {
            print("Could not decode >:(")
        }
    }
    
}
