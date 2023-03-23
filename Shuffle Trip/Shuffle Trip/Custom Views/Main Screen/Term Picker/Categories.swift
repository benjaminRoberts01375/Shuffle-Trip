// Mar 22, 2023
// Ben Roberts

import SwiftUI

struct Categories: View {
    @StateObject var topics: CategoryDataM
    
    var body: some View {
        ScrollViewReader { proxy in
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
            .overlay(sectionIndexTitles(proxy: proxy))
        }
    }
    
    func sectionIndexTitles(proxy: ScrollViewProxy) -> some View {
        Overview(proxy: proxy, topics: topics)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
    }
}

struct Overview: View {
    let proxy: ScrollViewProxy
    let topics: CategoryDataM
    @GestureState private var dragLocation: CGPoint = .zero
    
    var body: some View {
        EmptyView()
        VStack(alignment: .trailing) {
            ForEach(topics.topics.sorted(by: { (lhs, rhs) -> Bool in    // List all topics as icons and sort alphabetically
                lhs.topic < rhs.topic
            }), id: \.topic) { topic in
                Color.clear
                    .frame(width: 30, height: 20)
                    .overlay(
                        Image(systemName: topic.symbol)
                            .foregroundColor(.blue)
                            .opacity(0.75)
                            .background(dragObserver(title: topic.topic))
                    )
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
        )
    }
    
    func dragObserver(title: String) -> some View {
            GeometryReader { geometry in
                dragObserver(geometry: geometry, title: title)
            }
        }
    
    func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                proxy.scrollTo(title, anchor: .center)
            }
        }
        return Rectangle().fill(Color.clear)
    }
}

struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        Categories(topics: CategoryDataM())
    }
}
