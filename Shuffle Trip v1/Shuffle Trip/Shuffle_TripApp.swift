// Dec 1, 2022
// Ben Roberts

import SwiftUI

@main
struct Shuffle_TripApp: App {
    @State var validLogin = false
    
    var body: some Scene {
        WindowGroup {
            TabManager()
        }
    }
}
