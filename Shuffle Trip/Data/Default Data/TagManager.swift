// Apr 11, 2023
// Ben Roberts

import SwiftUI

/// Allows for simple interaction with the term groups,
final class TagManager: ObservableObject {
    /// Accessor for singleton object
    public static var shared: TagManager = TagManager()
    
    /// All the groups of topics from JSON
    @Published private(set) var topicGroups: [TopicGroup]
    
    private init() {
        self.topicGroups = []
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
            self.topicGroups = try JSONDecoder().decode([TopicGroup].self, from: data)                            // Decode loaded data and store it
            
        } catch let error {                                                                                     // Catch-all for loading/decoding errors
            fatalError("Unable to parse categories JSON:\n\(error)")
        }
    }
        
    /// Searches for the tag ID specified
    /// - Parameter id: UUID of the tag to search for
    /// - Returns: An optional Tag if found
    private func searchID(id: UUID) -> Tag? {
        for group in topicGroups {                   // Search each group
            for topic in group.topics {                 // Search each topic
                for tag in topic.tags where tag.id == id {  // For the correct tag
                    return tag                                  // And return it
                }
            }
        }
        return nil
    }
    
    /// Provides the topic to a provided tag
    /// - Parameter tag: Tag to search for
    /// - Returns: An optional Topic if found
    private func locateTagParent(tag: Tag) -> Topic? {
        for group in topicGroups {
            for topic in group.topics where topic.tags.contains(where: { $0 == tag }) {
                return topic
            }
        }
        return nil
    }
}
