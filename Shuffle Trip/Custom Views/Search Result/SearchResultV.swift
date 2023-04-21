// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

struct SearchResultV: View {
    @StateObject var controller: SearchResultVM
    
    init(locationResult: MKMapItem) {
        self._controller = StateObject(wrappedValue: SearchResultVM(locationResult: locationResult))
    }
    
    var body: some View {
        HStack {
            EmptyView()
        }
    }
}

struct SearchResultV_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultV(locationResult: MKMapItem(placemark: MKPlacemark(coordinate: MapDetails.location1)))
    }
}
