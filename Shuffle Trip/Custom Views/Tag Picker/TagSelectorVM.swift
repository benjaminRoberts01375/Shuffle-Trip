// Apr 14, 2023
// Ben Roberts

import SwiftUI

final class TagSelectorVM: ObservableObject {
    let group: TopicGroup
    let selected: [UUID]
    
    init(group: TopicGroup) {
        self.group = group
        self.selected = []
    }
    
    /// Checks each ID from a given topic to see if each topic is selected
    /// - Parameter topic: Topic to check against
    /// - Returns: Boolean value if each topic is selected
    internal func topicIsSelected(topic: Topic) -> Bool{
        for tag in topic.tags where !selected.contains(tag.id) {
            return false
        }
        return true
    }
}
