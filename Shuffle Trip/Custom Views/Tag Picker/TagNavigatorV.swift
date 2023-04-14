// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct TagNavigatorV: View {
    @StateObject var controller: TagNavigatorVM
    @State var selection: TopicGroup?
    
    init() {
        self._controller = StateObject(wrappedValue: TagNavigatorVM())
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
                        //                        TagSelectorV(num: group)
                        EmptyView()
                    } label: {
                        HStack {
                            Image(systemName: group.symbol)
                            Text("\(group.name)")
                        }
                    }
                }
                .navigationTitle("Categories")
            } detail: {
                Text("Choose a recipe")
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
}

struct TagNavigatorV_Previews: PreviewProvider {
    static var previews: some View {
        TagNavigatorV()
    }
}
