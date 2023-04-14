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
    
}
