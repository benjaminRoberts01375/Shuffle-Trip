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
                }), id: \.topic) { majorCategory in
                    Section {                                                               // Devide the major categories
                        HStack {
                            Text(majorCategory.topic)
                                .font(.title2.bold())
                            Image(systemName: majorCategory.symbol)
                        }

                        ForEach(majorCategory.catagories.sorted(), id: \.self) { minorCategory in // List all minor categories and sort alphabetically
                            Text(minorCategory)
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
