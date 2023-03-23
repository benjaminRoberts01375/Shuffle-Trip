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
        let categories: [String]
        let topic: String
        var selected: [String] = []
        
        enum CodingKeys: String, CodingKey {
            case symbol
            case categories = "data"
            case topic = "category"
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
    
    /// Allows for keeping track of which category the user selected. This will not duplicate a selection.
    /// - Parameters:
    ///   - topic: Topic that the category is a part of
    ///   - category: Category to select
    public func SelectCategory(topic: String, category: String) {
        guard var topic: Topic = topics.first(where: { $0.topic == topic }) else { return }
        if !topic.selected.contains(category) && topic.categories.contains(category) {
            topic.selected.append(category)
        }
    }
    
    /// Deselect a selected category. This will remove any and all duplicates of this category.
    /// - Parameters:
    ///   - topic: Topic that the category is a part of
    ///   - category: Category to deselect
    public func DeselectCategory(topic: String, category: String) {
        guard var topic: Topic = topics.first(where: { $0.topic == topic }) else { return }
        topic.selected.removeAll(where: { $0 == category })
    }
    
    /// Checks to see if a category within a topic is selected.
    /// - Parameters:
    ///   - topic: Topic that the category is a part of.
    ///   - category: Category to check.
    /// - Returns: Bool of if the category is selected within the specified topic.
    public func CategoryIsSelected(topic: String, category: String) -> Bool {
        guard var topic: Topic = topics.first(where: { $0.topic == topic }) else { return false }
        return topic.selected.contains(category)
    }
}
