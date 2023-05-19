// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct TagSelectorV: View {
    @StateObject var controller: TagSelectorVM
    @State var searchText: String
    
    init(group: TopicGroup, activity: Activity) {
        self._controller = StateObject(wrappedValue: TagSelectorVM(group: group, activity: activity))
        self._searchText = State(initialValue: "")
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { _ in
                VStack(alignment: .leading) {
                    List(controller.group.topics) { topic in
                        Section {
                            DisclosureGroup(
                                content: {
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
                                },
                                label: {
                                    Button {
                                        controller.toggleTopicSelection(topic: topic)
                                    } label: {
                                        HStack {
                                            Text(topic.name)
                                                .font(.title2.bold())
                                                .foregroundColor(Color.primary)
                                                .padding(0)
                                            Image(systemName: topic.symbol)
                                                .foregroundColor(controller.topicIsSelected(topic: topic) ? .blue : .primary)
                                        }
                                        .foregroundColor(.primary)
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search \(controller.group.name.lowercased()) tags")
        }
        .navigationTitle("\(controller.group.name) Tags")
    }
}
