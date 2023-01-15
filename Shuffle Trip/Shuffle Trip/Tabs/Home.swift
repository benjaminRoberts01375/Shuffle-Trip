// December 1, 2022
// Ben Roberts

import SwiftUI
import MapKit

struct Home: View {
    var size: CGFloat = 250
    var pastLocations: [LocationInfo] = [
        LocationInfo(name: MapDetails.title1, region: MapDetails.region1, transportType: "car"),
        LocationInfo(name: MapDetails.title2, region: MapDetails.region2, transportType: "walk")
    ]
    
    struct LocationInfo: Identifiable {
        let id = UUID()
        let name: String
        let region: MKCoordinateRegion
        let transportType: String
        var image: UIImage? {
            if transportType == "scooter" {
                return UIImage(systemName: "scooter")
            }
            else if transportType == "car" {
                return UIImage(systemName: "car")
            }
            else {
                return UIImage(systemName: "figure.walk")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(pastLocations) {location in
                            NavigationLink(destination: RegionSelector(region: location.region, pinImage: location.image, pinCoordinate: location.region.center), label: {
                                MapIcon(region: location.region, pinImage: location.image!, title: location.name)
                            })
                            .frame(width: 250, height: 250)
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(16)
                            .shadow(radius: 5)
                            .padding(.horizontal, 10)
                            
                            
                        }
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 10.0)
                }
                .navigationTitle("Home")
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
