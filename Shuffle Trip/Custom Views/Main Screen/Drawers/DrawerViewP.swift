// Mar 16, 2023
// Ben Roberts

import SwiftUI

protocol DrawerView {
    associatedtype Header: View
    associatedtype Body: View
    
    var header: Header { get }
    var body: Body { get }
}
