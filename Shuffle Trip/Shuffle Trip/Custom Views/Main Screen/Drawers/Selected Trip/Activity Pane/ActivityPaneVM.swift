// Mar 20, 2023
// Ben Roberts

import SwiftUI

final class ActivityPaneVM: ObservableObject {
    @Published var activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
    }
}
