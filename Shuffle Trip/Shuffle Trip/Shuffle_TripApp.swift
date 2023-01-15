//
//  Shuffle_TripApp.swift
//  Shuffle Trip
//
//  Created by Ben Roberts on 12/1/22.
//

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
