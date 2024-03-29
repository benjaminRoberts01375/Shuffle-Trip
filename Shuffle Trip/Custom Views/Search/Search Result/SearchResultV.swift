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
            controller.symbol
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(controller.color)
                .font(.title)
            VStack(alignment: .leading) {
                Text(controller.locationResult.name ?? "Unknown Location")
                    .foregroundColor(Color.primary)
                    .multilineTextAlignment(.leading)
                Text(controller.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
    }
}

struct SearchResultV_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchResultV(locationResult: MKMapItem(placemark: MKPlacemark(coordinate: MapDetails.location1)))
            SearchResultV(locationResult: MKMapItem(placemark: MKPlacemark(coordinate: MapDetails.location1)))
            SearchResultV(locationResult: MKMapItem(placemark: MKPlacemark(coordinate: MapDetails.location1)))
            SearchResultV(locationResult: MKMapItem(placemark: MKPlacemark(coordinate: MapDetails.location1)))
            SearchResultV(locationResult: MKMapItem(placemark: MKPlacemark(coordinate: MapDetails.location1)))
        }
    }
}
