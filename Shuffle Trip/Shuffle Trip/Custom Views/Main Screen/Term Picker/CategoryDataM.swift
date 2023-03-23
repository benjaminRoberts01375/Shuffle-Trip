// Mar 22, 2023
// Ben Roberts

import Foundation
import SwiftUI

final class CategoryDataM: ObservableObject {
    /// A list of all categories available to Shuffle Trip
    @Published private(set) var topics: [Topic]
    
    init() {
        self.topics = []
        LoadData()
    }
    
    // swiftlint:disable nesting
    public struct Topic: Codable {
        let symbol: String
        let catagories: [String]
        let topic: String
        
        enum CodingKeys: String, CodingKey {
            case symbol
            case catagories = "data"
            case topic = "catagory"
        }
    }
    // swiftlint:enable nesting
    
    /// Load category data into memory
    private func LoadData() {
        // Load the JSON file
        guard let fileURL = Bundle.main.url(forResource: "Categories", withExtension: "json") else {    // Name of the categories file
            fatalError("Unable to find Categories.json")
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            self.topics = try decoder.decode([Topic].self, from: data)
            print(topics.count)
            for category in topics {
                print(category.topic)
            }
        } catch {
            fatalError("Unable to parse data.json: \(error)")
        }
        
        do {
            let data = try Data(contentsOf: fileURL)                 // Raw JSON data
            let decoder = JSONDecoder()                              // Decoder for JSON to structs
            topics = try decoder.decode([Topic].self, from: data)    // Decode JSON to structs
        }
        catch {
            print("Could not decode >:(")
        }
    }
}
