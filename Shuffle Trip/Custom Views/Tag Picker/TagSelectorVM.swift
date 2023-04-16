// Apr 14, 2023
// Ben Roberts

import SwiftUI

final class TagSelectorVM: ObservableObject {
    let group: TopicGroup
    @Published var activity: Activity
    
    init(group: TopicGroup, activity: Activity) {
        self.group = group
        self.activity = activity
    }
    
    /// Checks each ID from a given topic to see if each topic is selected
    /// - Parameter topic: Topic to check against
    /// - Returns: Boolean value if each topic is selected
    internal func topicIsSelected(topic: Topic) -> Bool {
        for tag in topic.tags where !activity.tagIDs.contains(tag.id) {
            return false
        }
        return true
    }
    
    /// Check for if a given tag is selected
    /// - Parameter tag: Tag to check
    /// - Returns: Bool of if the tag is selected
    internal func tagIsSelected(tag: Tag) -> Bool {
        return activity.tagIDs.contains(tag.id)
    }
    
    /// Add or remove a tag from the selection
    /// - Parameter tag: Tag to add or remove
    internal func toggleTagSelection(tag: Tag) {
        if tagIsSelected(tag: tag) {
            activity.removeTag(tagID: tag.id)
        }
        else {
            activity.addTag(tagID: tag.id)
        }
        self.objectWillChange.send()
    }
    
    /// Logic for checking if a topic should be shown at all in the search results
    /// - Parameters:
    ///   - search: Search phrase
    ///   - topic: Topic to check
    /// - Returns: Bool of if the topic should be displayed
    internal func displayTopic(search: String, topic: Topic) -> Bool {
        if search == "" { return true }
        
        for tag in topic.tags where displayTag(search: search, tagName: tag.name, topicName: topic.name) {
            return true
        }
        return false
    }
    
    /// Logic for checking if a tag should be shown in the search results
    /// - Parameters:
    ///   - search: Search phrase
    ///   - tagName: Name of a given tag
    ///   - topicName: Name of a given topic
    /// - Returns: Bool of if the tag should be displayed
    internal func displayTag(search: String, tagName: String, topicName: String) -> Bool {
        return
        (
            search == "" ||
            tagName.lowercased().contains(search.lowercased()) ||
            topicName.lowercased().contains(search.lowercased())
        )
    }
    
    /// Selects or deselects all tags for a topic
    /// - Parameter topic: Topic to (de)select
    internal func toggleTopicSelection(topic: Topic) {
        if activity.topicIsSelected(topic: topic) {
            activity.deselectTopic(topic: topic)
        }
        else {
            activity.selectTopic(topic: topic)
        }
        self.objectWillChange.send()
    }
}
