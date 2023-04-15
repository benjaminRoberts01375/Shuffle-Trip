// Apr 14, 2023
// Ben Roberts

import SwiftUI

final class TagSelectorVM: ObservableObject {
    let group: TopicGroup
    @Published var search: String
    @Published var activity: Activity
    
    init(group: TopicGroup, activity: Activity) {
        self.group = group
        self.search = ""
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
}
