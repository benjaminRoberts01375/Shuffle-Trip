// Mar 22, 2023
// Ben Roberts

import SwiftUI

struct Categories: View {
    @StateObject var topics: CategoryDataM
    
    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(topics.topics.sorted(by: { (lhs, rhs) -> Bool in            // List all topics and sort alphabetically
                    lhs.topic < rhs.topic
                }), id: \.topic) { topic in
                    Section {                                                       // Devide the topics
                        Button(action: {
                            if topics.CheckTopicSelection(topic: topic.topic) {
                                topics.DeselectTopic(topic: topic.topic)
                            }
                            else {
                                topics.SelectTopic(topic: topic.topic)
                            }
                        }, label: {
                            HStack {
                                Text(topic.topic)
                                    .font(.title2.bold())
                                    .foregroundColor(Color.primary)
                                Image(systemName: topic.symbol)
                                    .foregroundColor(topics.CheckTopicSelection(topic: topic.topic) ? .blue : .primary)
                            }
                        })
                        .padding(.vertical, 5)
                        .listRowBackground(BlurView(style: .prominent, opacity: 1))
                        
                        ForEach(topic.categories.sorted(), id: \.self) { category in // List all categories and sort alphabetically
                            HStack {
                                Image(systemName: "checkmark")
                                    .opacity(topics.CategoryIsSelected(topic: topic.topic, category: category) ? 1 : 0)
                                    .foregroundColor(.blue)
                                Button(action: {
                                    if topics.CategoryIsSelected(topic: topic.topic, category: category) {
                                        topics.DeselectCategory(topic: topic.topic, category: category)
                                    }
                                    else {
                                        topics.SelectCategory(topic: topic.topic, category: category)
                                    }
                                }, label: {
                                    Text(category)
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

struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        Categories(topics: CategoryDataM())
    }
}
