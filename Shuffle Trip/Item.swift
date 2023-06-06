// Created on 6/6/23 by Ben Roberts
// Created for Shuffle Trip
//
// Swift 5.0

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
