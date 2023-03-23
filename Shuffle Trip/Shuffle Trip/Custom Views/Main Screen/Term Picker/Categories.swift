// Mar 22, 2023
// Ben Roberts

import SwiftUI

struct Categories: View {
    var topics: CategoryDataM
    
    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(topics.topics.sorted(by: { (lhs, rhs) -> Bool in            // List all major categories and sort alphabetically
                    lhs.topic < rhs.topic
                }), id: \.topic) { topic in
                    Section {                                                               // Devide the major categories
                        HStack {
                            Text(topic.topic)
                                .font(.title2.bold())
                            Image(systemName: topic.symbol)
                        }

                        ForEach(topic.categories.sorted(), id: \.self) { category in // List all minor categories and sort alphabetically
                            Text(category)
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
