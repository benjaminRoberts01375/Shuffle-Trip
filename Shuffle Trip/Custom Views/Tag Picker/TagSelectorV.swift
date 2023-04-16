// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct TagSelectorV: View {
    @StateObject var controller: TagSelectorVM
    @State var searchText: String
    
    init(group: TopicGroup, activity: Activity) {
        self._controller = StateObject(wrappedValue: TagSelectorVM(group: group, activity: activity))
        searchText = ""
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { _ in
                List {
                    ForEach(controller.group.topics.sorted(by: { (lhs, rhs) -> Bool in  // List all topics and sort alphabetically
                        lhs.name < rhs.name
                    }), id: \.name) { topic in
                        if controller.displayTopic(search: searchText, topic: topic) {
                            Section {
                                Button(action: {
                                    controller.toggleTopicSelection(topic: topic)
                                }, label: {
                                    HStack {
                                        Text(topic.name)
                                            .font(.title2.bold())
                                            .foregroundColor(Color.primary)
                                        Image(systemName: topic.symbol)
                                            .foregroundColor(controller.topicIsSelected(topic: topic) ? .blue : .primary)
                                    }
                                })
                                ForEach(topic.tags.sorted(by: { (lhs, rhs) -> Bool in           // List all tags and sort alphabetically
                                    lhs.name < rhs.name
                                }), id: \.name) { tag in
                                    if controller.displayTag(search: searchText, tagName: tag.name, topicName: topic.name) {
                                        HStack {
                                            Image(systemName: "checkmark")
                                                .opacity(controller.tagIsSelected(tag: tag) ? 1 : 0)
                                                .foregroundColor(.blue)
                                            Button(action: {
                                                controller.toggleTagSelection(tag: tag)
                                            }, label: {
                                                Text(tag.name)
                                                    .foregroundColor(Color.primary)
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search \(controller.group.name.lowercased()) tags")
        }
        .navigationTitle("\(controller.group.name) Tags")
    }
}
