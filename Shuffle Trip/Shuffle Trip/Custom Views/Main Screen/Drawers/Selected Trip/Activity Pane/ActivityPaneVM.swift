// Mar 20, 2023
// Ben Roberts

import SwiftUI

final class ActivityPaneVM: ObservableObject {
    @Published var activity: Activity
    var index: Int
    
    init(activity: Activity, index: Int) {
        self.activity = activity
        self.index = index
    }
}
