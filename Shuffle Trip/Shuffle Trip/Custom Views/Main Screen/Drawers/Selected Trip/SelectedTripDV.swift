// Feb 17, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripDV: DrawerView {
    @ObservedObject var controller: SelectedTripVM
    
    init(tripLocations: TripLocations) {
        self._controller = ObservedObject(wrappedValue: SelectedTripVM(tripLocations: tripLocations))
    }
    
    var header: some View {
        VStack {
            if controller.selectedTrip != nil {
                switch controller.displayPhase {
                case .info:
                        HStack {
                            TextField("Name of trip", text: $controller.selectedTrip.name)
                                .font(.title2.weight(.bold))
                            Spacer()
                                
                            switch controller.shuffleConfirmation {
                            case .normal:
                                HStack {
                                    Button(action: {
                                        controller.selectedTrip.isShared.toggle()
                                    }, label: {
                                        Image(systemName: controller.selectedTrip.isShared ? "person.2.circle.fill" : "person.circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(controller.selectedTrip.isShared ? .blue : Color.secondary)
                                            .font(Font.title.weight(.bold))
                                    })
                                    Button(action: {                            // Shuffle button
                                        withAnimation {
                                            controller.shuffleConfirmation = .confirmShuffle
                                        }
                                    }, label: {
                                        Image(systemName: "shuffle.circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(Color.secondary)
                                            .font(Font.title.weight(.bold))
                                    })
                                    Button(action: {                            // Close card button
                                        controller.tripLocations.SelectTrip()
                                    }, label: {
                                        Image(systemName: "chevron.down.circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(Color.secondary)
                                            .font(Font.title.weight(.bold))
                                    })
                                }
                            case .confirmShuffle:
                                HStack {
                                    Text("Confirm")
                                        .font(Font.headline.weight(.bold))
                                    Button(action: {                            // Confirm shuffle - No
                                        withAnimation {
                                            controller.shuffleConfirmation = .normal
                                            
                                        }
                                    }, label: {
                                        Image(systemName: "arrow.uturn.backward.circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(Color.green)
                                            .font(Font.title.weight(.bold))
                                    })
                                    Button(action: {                            // Confirm shuffle - Yes
                                        controller.selectedTrip.ShuffleTrip()
                                        withAnimation {
                                            controller.shuffleConfirmation = .normal
                                        }
                                    }, label: {
                                        Image(systemName: "shuffle.circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(Color.red)
                                            .font(Font.title.weight(.bold))
                                    })
                                }
                                .padding(5)
                                .background(BlurView(style: .systemUltraThinMaterial, opacity: 0))
                                .cornerRadius(40)
                                .transition(.opacity)
                            }
                        }
                case .loading:
                    LoadingTripDV().header
                case .error:
                    TripErrorDV(tripLocations: controller.tripLocations).header
                }
            }
            else {
                EmptyView()
            }
        }
        .onReceive(controller.tripLocations.objectWillChange) { _ in
            controller.setDisplayPhase()
        }
        .onAppear {
            controller.setDisplayPhase()
        }
        .onChange(of: controller.shuffleConfirmation) { _ in
            if controller.shuffleConfirmation == .normal {
                print("Normal buttons")
            }
            else {
                print("Confirm buttons")
            }
        }
    }
    
    var body: some View {
        VStack {
            if controller.selectedTrip != nil {
                switch controller.displayPhase {
                case .info:
                    VStack {
                        ForEach(Array(controller.selectedTrip.activityLocations.enumerated()), id: \.1.self) { index, activity in
                            ActivityPaneV(activity: activity, index: index + 1)
                        }
                    }
                case .loading:
                    LoadingTripDV().body
                case .error:
                    TripErrorDV(tripLocations: controller.tripLocations).body
                }
            }
            else {
                EmptyView()
            }
        }
    }
}
