// Apr 16, 2023
// Ben Roberts

import SwiftUI

final class UngeneratedActivityPaneVM: ObservableObject {
    /// Activity the pane is for
    let activity: Activity
    /// Controller for the tag picker sheet
    @Published var showTagPicker: Bool
    
    init(activity: Activity) {
        self.activity = activity
        self.showTagPicker = false
    }
}
