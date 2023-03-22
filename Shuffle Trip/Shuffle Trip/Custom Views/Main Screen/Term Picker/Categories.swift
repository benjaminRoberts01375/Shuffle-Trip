// Mar 22, 2023
// Ben Roberts

import SwiftUI

struct Categories: View {
    var categories: CategoryDataM
    
    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(categories.categories.sorted(by: { (lhs, rhs) -> Bool in
                    lhs.category < rhs.category
                }), id: \.category) { test in
                    Text(test.category)
                }
            }
        }
    }
}

struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        Categories(categories: CategoryDataM())
    }
}
