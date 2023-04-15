// Apr 14, 2023
// Ben Roberts

import SwiftUI

final class TagNavigatorVM: ObservableObject {
    let activity: Activity
    
    init(activity: Activity) {
        self.activity = activity
    }
}
