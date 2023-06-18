//
//  Shuffle_TripApp.swift
//  Shuffle Trip
//
//  Created by Ben Roberts on 1/24/23.
//

import MapKit
import SwiftUI

@main
struct ShuffleTripApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
