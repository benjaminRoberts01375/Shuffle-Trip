// Mar 16, 2023
// Ben Roberts

import SwiftUI

protocol DrawerView {
    associatedtype Content: View
    
    var header: Content { get }
    var body: Content { get }
}
