// Apr 14, 2023
// Ben Roberts

import SwiftUI

struct AddActivityButtonV: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Image(systemName: "plus.circle.fill")
                .symbolRenderingMode(.multicolor)
        })
    }
}

struct AddActivityButtonV_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityButtonV()
    }
}
