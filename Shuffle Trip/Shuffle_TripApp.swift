// Created on 6/6/23 by Ben Roberts
// Created for Shuffle Trip
//
// Swift 5.0

import SwiftData
import SwiftUI

@main
struct Shuffle_TripApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
