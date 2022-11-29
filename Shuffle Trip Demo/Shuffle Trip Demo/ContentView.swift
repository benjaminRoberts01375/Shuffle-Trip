//
//  ContentView.swift
//  Shuffle Trip Demo
//
//  Created by Ben Roberts on 11/26/22.
//

import SwiftUI
import MapKit

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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
