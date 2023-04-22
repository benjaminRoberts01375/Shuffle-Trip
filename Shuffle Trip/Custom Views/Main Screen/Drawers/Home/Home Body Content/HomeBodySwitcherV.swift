// Apr 21, 2023
// Ben Roberts

import CodeScanner
import MapKit
import SwiftUI

struct HomeBodySwitcherV: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var controller: HomeBodySwitcherVM
    
    init(tripLocations: TripLocations, searchTracker: LocationSearchTrackerM) {
        self._controller = StateObject(wrappedValue: HomeBodySwitcherVM(tripLocations: tripLocations, searchTracker: searchTracker))
    }
    
    var body: some View {
        switch controller.displayPhase {
        case .normal:
            VStack {
                HStack {
                    Text("Hello, \(UserLoginM.shared.name ?? "")")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Menu {
                        Button(action: {
                            controller.displayPhase = .presentQRCode
                        }, label: {
                            HStack {
                                Image(systemName: "qrcode")
                                Text("Present Code")
                            }
                        })
                        Button(action: {
                            controller.displayPhase = .readQRCode
                        }, label: {
                            HStack {
                                Image(systemName: "qrcode.viewfinder")
                                Text("Scan Code")
                            }
                        })
                    } label: {
                        Image(systemName: "person.2.circle.fill")
                            .font(.title2)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                Divider()
                    .padding(.bottom)
                
                if !FriendTripProfiles.shared.friends.isEmpty {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Friend Trips")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(FriendTripProfiles.shared.friends) { friend in
                                    ForEach(friend.trips) { trip in
                                        VStack {
                                            MapIconV(
                                                region: MKCoordinateRegion(
                                                    center: CLLocationCoordinate2D(
                                                        latitude: trip.latitude,
                                                        longitude: trip.longitude
                                                    ),
                                                    latitudinalMeters: Double(trip.radius) * 1.2,
                                                    longitudinalMeters: Double(trip.radius) * 1.2
                                                ),
                                                activities: trip.activities,
                                                
                                                title: "Burlington"
                                            )
                                            .frame(width: 250, height: 250)
                                            .edgesIgnoringSafeArea(.all)
                                            .cornerRadius(16)
                                            .padding(.horizontal, 10)
                                            .shadow(radius: 5)
                                            .padding(.vertical, 10)
                                            Text(trip.name)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Divider()
                }
            }
        case .tripSearch:
            VStack {
                SearchV(searchTracker: controller.searchTracker, filter: false, selectionAction: { tripItem in
                    controller.addTrip(trip: tripItem)
                    dismiss()
                })
            }
        case .presentQRCode:
            VStack {
                Text("Your friend code:")
                    .font(.title)
                    .fontWeight(.bold)
                Image(uiImage: QRM.generateQRCode(data: UserLoginM.shared.userID ?? ""))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                
                Button(action: {
                    controller.displayPhase = .normal
                }, label: {
                    Text("Back")
                        .padding(5)
                        .foregroundColor(Color.primary)
                        .background(.quaternary)
                        .cornerRadius(10)
                })
            }
        case .readQRCode:
            VStack {
                Text("Scanning")
                CodeScannerView(codeTypes: [.qr], isTorchOn: false, completion: controller.scan)
                Button(action: {
                    controller.displayPhase = .normal
                }, label: {
                    Text("Back")
                        .padding(5)
                        .foregroundColor(Color.primary)
                        .background(.quaternary)
                        .cornerRadius(10)
                })
                
            }
        }
        
        EmptyView()
            .onReceive(controller.searchTracker.objectWillChange) {
                controller.setDisplayPhase()
            }
            .onAppear {
                controller.setDisplayPhase()
            }
            .onReceive(FriendTripProfiles.shared.objectWillChange) { _ in
                controller.objectWillChange.send()
            }
    }
}
