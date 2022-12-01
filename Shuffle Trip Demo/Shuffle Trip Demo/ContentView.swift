//
//  ContentView.swift
//  Shuffle Trip Demo
//
//  Created by Ben Roberts on 11/26/22.
//

import SwiftUI
import MapKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    @State private var followUser: Bool = true
    @State private var MapLocations: [MapLocation] = []
    
    struct MapLocation: Identifiable {
        let id = UUID()
        let name: String
        let latitude: Double
        let longitude: Double
        var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: MapLocations, annotationContent: { location in MapMarker(coordinate: location.coordinate, tint: .red)})
                    .accentColor(Color(.systemBlue))
                    .ignoresSafeArea()
                    .onAppear {
                        viewModel.checkIfLocationServicesIsEnabled()
                    }
                Circle()
                    .fill(.blue)
                    .opacity(0.2)
                    .frame(width: 200, height: 200)
            }
            HStack {
                Button(action: {
                    self.buttonTrigger(locationType: "Breakfast")
                }) {
                    Text("Breakfast")
                }
                
                Button(action: {
                    self.buttonTrigger(locationType: "Lunch")
                }) {
                    Text("Lunch")
                }
                
                Button(action: {
                    self.buttonTrigger(locationType: "Dinner")
                }) {
                    Text("Dinner")
                }
            }
        }
    }
    
    func buttonTrigger(locationType: String) {
        print("Function ran")
        struct TripSetupParams: Codable {
            let latitude: Double
            let longitude: Double
            let activities: [term]
        }
        struct term: Codable {
            let term: String
        }
        
        struct JSONTripStop: Decodable {
            let status: Int
            let message: String
            let data: ActivityData
        }
        
        struct ActivityData: Decodable {
            let activities: [Activities]
            let errors: [Int]
        }
        
        struct Activities: Decodable {
            let coordinates: ActivityCoordinate
            let name: String
        }
        
        struct ActivityCoordinate: Decodable {
            let latitude: Double
            let longitude: Double
        }
        
        
        let parameters = TripSetupParams(latitude: viewModel.region.center.latitude, longitude: viewModel.region.center.longitude, activities: [term(term: locationType)])
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = (try? encoder.encode(parameters))!
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/st/getdata/")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic am9lLm1hcmNoZXNpbmk6TWFyY2gxMDI3", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            print("Pre-Decode:")
            print(String(data: data, encoding: .utf8)!)
            print("\n")
            let tripStops: JSONTripStop = try! JSONDecoder().decode(JSONTripStop.self, from: data)
            print("\n\n\n\n\n\nPost-Decode")
//            print(String(data: tripStops, encoding: .utf8))

            print("\n\n\n\n\n Data:")
            print(tripStops.data)
            
            MapLocations.append(MapLocation(name: tripStops.data.activities[0].name, latitude: tripStops.data.activities[0].coordinates.latitude, longitude: tripStops.data.activities[0].coordinates.longitude))

//            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
