// Mar 16, 2023
// Ben Roberts

import SwiftUI

protocol DrawerView {
    associatedtype Header: View
    associatedtype Body: View
    
    /// What to show in the header of a card
    var header: Header { get }
    /// What to show in the body of a card
    var body: Body { get }
}
