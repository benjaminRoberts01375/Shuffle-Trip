// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct TagNavigatorV: View {
    @StateObject var controller: TagNavigatorVM
    @State var selection: Int?
    
    init() {
        self._controller = StateObject(wrappedValue: TagNavigatorVM())
    }
    
    var body: some View {
        VStack {
            NavigationSplitView {
                List(0..<10, selection: $selection) { number in
//                    Text("Number: \(number)")
                    NavigationLink {
                        TagSelectorV(num: number)
                    } label: {
                        Text(String(number))
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
