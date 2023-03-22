// Mar 22, 2023
// Ben Roberts

import SwiftUI

final class TermPickerM: Codable, ObservableObject {
    var symbol: String
    var data: [String]
    var name: String
    
    init(symbol: String, data: [String], name: String) {
        self.symbol = symbol
        self.data = data
        self.name = name
    }
}
