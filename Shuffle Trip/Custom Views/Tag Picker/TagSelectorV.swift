// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct TagSelectorV: View {
    let num: Int
    
    var body: some View {
        Text("Your number is \(num)")
    }
}

struct TagSelector_Previews: PreviewProvider {
    static var previews: some View {
        TagSelectorV(num: 0)
    }
}
