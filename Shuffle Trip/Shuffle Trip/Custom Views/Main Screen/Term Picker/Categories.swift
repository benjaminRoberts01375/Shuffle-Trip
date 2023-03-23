// Mar 22, 2023
// Ben Roberts

import SwiftUI

struct Categories: View {
    var categories: CategoryDataM
    
    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(categories.categories.sorted(by: { (lhs, rhs) -> Bool in            // List all major categories and sort alphabetically
                    lhs.category < rhs.category
                }), id: \.category) { majorCategory in
                    Section {                                                               // Devide the major categories
                        HStack {
                            Text(majorCategory.category)
                                .font(.title2.bold())
                            Image(systemName: majorCategory.symbol)
                        }

                        ForEach(majorCategory.data.sorted(), id: \.self) { minorCategory in // List all minor categories and sort alphabetically
                            Text(minorCategory)
                        }
                    }
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
