// Mar 20, 2023
// Ben Roberts

import SwiftUI

struct ActivityPaneV: View {
    
    @StateObject var controller: ActivityPaneVM
    
    init(activity: Activity) {
        self._controller = StateObject(wrappedValue: ActivityPaneVM(activity: activity))
    }
    
    var body: some View {
        DisclosureGroup(content: {
            VStack {
                EmptyView()
            }
        }, label: {
            Text("\(controller.activity.businesses[0].name)")
        })
    }
}
