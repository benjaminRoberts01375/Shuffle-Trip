// Mar 20, 2023
// Ben Roberts

import SwiftUI

struct ActivityPaneV: View {
    
    @StateObject var controller: ActivityPaneVM
    
    init(activity: Activity, index: Int) {
        self._controller = StateObject(wrappedValue: ActivityPaneVM(activity: activity, index: index))
    }
    
    var body: some View {
        DisclosureGroup(content: {
            VStack {
                EmptyView()
            }
        }, label: {
            HStack {
                Image(systemName: "\(controller.index).circle.fill")
                Text("\(controller.activity.businesses[0].name)")
            }
            .foregroundColor(.primary)
        })
    }
}
