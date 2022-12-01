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
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .accentColor(Color(.systemBlue))
                .ignoresSafeArea()
                .onAppear {
                    viewModel.checkIfLocationServicesIsEnabled()
                }
            Button(action: {
                self.buttonTrigger()
            }) {
                Text("Test")
            }
        }
    }
    
    func buttonTrigger() {
        print("Function ran")
        struct TripSetupParams: Codable {
            var latitude: Double
            var longitude: Double
            var activities: [term]
        }
        struct term: Codable {
            var term: String
        }
        
        struct TripStop: Decodable {
            var latitude: Double
            var longitude: Double
            var name: String
        }
        
        let params = TripSetupParams(latitude: 44.475883, longitude: -73.212074, activities: [term(term: "lunch"), term(term: "museum"), term(term: "dinner")])
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try? encoder.encode(params)
        print(String(data: data!, encoding: .utf8)!)
        
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\r\n\"activities\": [{\"term\": \"lunch\"},{\"term\": \"museum\"},{\"term\": \"dinner\"}],\r\n \"latitude\": 44.475883,\r\n \"longitude\": -73.212074\r\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/st/getdata/")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic am9lLm1hcmNoZXNpbmk6TWFyY2gxMDI3", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          print(String(data: data, encoding: .utf8)!)
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
