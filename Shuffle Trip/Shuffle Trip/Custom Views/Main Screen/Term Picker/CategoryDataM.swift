// Mar 22, 2023
// Ben Roberts

import Combine
import Foundation
import SwiftUI

final class CategoryDataM: ObservableObject {
    /// A list of all categories available to Shuffle Trip
    @Published private(set) var topics: [Topic]
    /// For dealing with observers
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.topics = []
        LoadData()
    }
    
    public class Category: Decodable, ObservableObject {
        let name: String
        @Published var selected: Bool = false {
            didSet {
                objectWillChange.send()
            }
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.name = try container.decode(String.self)
        }
    }
    
    public class Topic: Decodable, ObservableObject {
        let symbol: String
        var categories: [Category]
        let topic: String
        
        // swiftlint:disable nesting
        enum CodingKeys: String, CodingKey {
            case symbol
            case categories = "data"
            case topic = "category"
        }
        // swiftlint:enable nesting
    }
    
    /// Load category data into memory
    private func LoadData() {
        // Load the JSON file
        guard let fileURL = Bundle.main.url(forResource: "Categories", withExtension: "json") else {
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
            
            for topic in topics {
                for category in topic.categories {
                    category.objectWillChange.sink { _ in
                        DispatchQueue.main.async {
                            self.objectWillChange.send()
                        }
                    }
                    .store(in: &cancellables)
                }
            }
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
        guard let topicIndex = topics.firstIndex(where: { $0.topic == topic }) else { return }
        guard let categoryIndex = topics[topicIndex].categories.firstIndex(where: { $0.name == category }) else { return }
        topics[topicIndex].categories[categoryIndex].selected = true
    }
    
    /// Deselect a selected category. This will remove any and all duplicates of this category.
    /// - Parameters:
    ///   - topic: Topic that the category is a part of
    ///   - category: Category to deselect
    public func DeselectCategory(topic: String, category: String) {
        guard let topicIndex = topics.firstIndex(where: { $0.topic == topic }) else { return }
        guard let categoryIndex = topics[topicIndex].categories.firstIndex(where: { $0.name == category && $0.selected }) else { return }
        topics[topicIndex].categories[categoryIndex].selected = false
    }
    
    /// Checks to see if a category within a topic is selected.
    /// - Parameters:
    ///   - topic: Topic that the category is a part of.
    ///   - category: Category to check.
    /// - Returns: Bool of if the category is selected within the specified topic.
    public func CategoryIsSelected(topic: String, category: String) -> Bool {
        guard let topic: Topic = topics.first(where: { $0.topic == topic }) else { return false }
        if topic.categories.contains(where: { $0.name == category && $0.selected }) {
            return true
        }
        return false
    }
    
    /// Selects all categories in a topic
    /// - Parameter topic: Topic to select
    public func SelectTopic(topic: String) {
        guard let topic: Topic = topics.first(where: { $0.topic == topic }) else { return }
        for i in 0...topic.categories.count {
            topic.categories[i].selected = true
        }
    }
    
    /// Deselects all categories in a topic
    /// - Parameter topic: Topic to deselect
    public func DeselectTopic(topic: String) {
        guard let topic: Topic = topics.first(where: { $0.topic == topic }) else { return }
        for i in 0...topic.categories.count {
            topic.categories[i].selected = false
        }
    }
    
    /// Checks to see if all categories within a topic are selected
    /// - Parameter topic: Topic to check
    /// - Returns: Bool of if the topic is selected or not
    public func CheckTopicSelection(topic: String) -> Bool {
        guard let topic: Topic = topics.first(where: { $0.topic == topic }) else { return false }
        for category in topic.categories where !category.selected {
            return false
        }
        return true
    }
    
    public func CheckEnoughSelected() -> Bool {
        let min: Int = 3
        var count: Int = 0
        
        for topic in topics {
            for category in topic.categories where category.selected {
                count += 1
            }
        }
        if count >= min {
            return true
        }
        return false
    }
}
