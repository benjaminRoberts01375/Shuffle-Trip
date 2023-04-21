// Apr 21, 2023
// Ben Roberts

import MapKit
import SwiftUI

final class SearchResultVM: ObservableObject {
    /// Location of something to do
    let locationResult: MKMapItem
    /// Symbol to display for location
    var symbol: Image
    /// Color for the location
    var color: Color
    
    // swiftlint:disable cyclomatic_complexity function_body_length
    init(locationResult: MKMapItem) {
        self.locationResult = locationResult
        guard let category = locationResult.pointOfInterestCategory
        else {
            symbol = Image(systemName: "circle.fill")
            color = Color.gray
            return
        }
        
        switch category {
        case .airport:
            symbol = Image(systemName: "airplane.circle.fill")
            color = Color.orange
        case .amusementPark:
            symbol = Image(systemName: "soccerball.circle.fill.inverse")
            color = Color.cyan
        case .aquarium, .marina:
            symbol = Image(systemName: "fish.circle.fill")
            color = Color.blue
        case .atm, .bank:
            symbol = Image(systemName: "dollarsign.circle.fill")
            color = Color.green
        case .bakery, .brewery, .cafe, .foodMarket, .restaurant, .winery:
            symbol = Image(systemName: "fork.knife.circle.fill")
            color = Color.orange
        case .beach:
            symbol = Image(systemName: "sun.and.horizon.circle.fill")
            color = Color.blue
        case .campground:
            symbol = Image(systemName: "tent.2.circle.fill")
            color = Color.green
        case .carRental, .evCharger, .gasStation, .parking, .publicTransport:
            symbol = Image(systemName: "car.circle.fill")
            color = Color.gray
        case .fireStation, .police:
            symbol = Image(systemName: "plus.circle.fill")
            color = Color.red
        case .fitnessCenter:
            symbol = Image(systemName: "figure.walk.circle.fill")
            color = Color.green
        case .hospital, .pharmacy:
            symbol = Image(systemName: "pills.circle.fill")
            color = Color.red
        case .hotel, .laundry:
            symbol = Image(systemName: "bed.double.circle.fill")
            color = Color.gray
        case .library, .school, .university:
            symbol = Image(systemName: "books.vertical.circle.fill")
            color = Color.brown
        case .nightlife:
            symbol = Image(systemName: "fire.circle.fill")
            color = Color.orange
        case .park:
            symbol = Image(systemName: "tree.circle.fill")
            color = Color.green
        case .postOffice:
            symbol = Image(systemName: "envelope.circle.fill")
            color = Color.blue
        case .restroom:
            symbol = Image(systemName: "toilet.circle.fill")
            color = Color.mint
        case .stadium:
            symbol = Image(systemName: "sportscourt.circle.fill")
            color = Color.red
        case .store:
            symbol = Image(systemName: "bag.circle.fill")
            color = Color.teal
        case .theater:
            symbol = Image(systemName: "popcorn.circle.fill")
            color = Color.red
        case .zoo:
            symbol = Image(systemName: "leaf.circle.fill")
            color = Color.green
        default:
            symbol = Image(systemName: "circle.fill")
            color = Color.gray
        }
    }
    // swiftlint:enable cyclomatic_complexity function_body_length
}
