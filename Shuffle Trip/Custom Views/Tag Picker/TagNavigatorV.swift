// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct TagNavigatorV: View {
    @StateObject var controller: TagNavigatorVM
    @State var selection: TopicGroup?
    
    init(activity: Activity) {
        self._controller = StateObject(wrappedValue: TagNavigatorVM(activity: activity))
    }
    
    var body: some View {
        VStack {
            NavigationSplitView {
                List(
                    TagManager.shared.topicGroups.sorted(
                        by: { (lhs, rhs) -> Bool in
                            lhs.name < rhs.name
                        }
                    ),
                    id: \.id,
                    selection: $selection
                ) { group in
                    NavigationLink {
                        TagSelectorV(group: group, activity: controller.activity)
                    } label: {
                        HStack {
                            Image(systemName: group.symbol)
                            Text("\(group.name)")
                        }
                    }
                }
                .navigationTitle("Categories")
            } detail: {
                EmptyView()
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
}
