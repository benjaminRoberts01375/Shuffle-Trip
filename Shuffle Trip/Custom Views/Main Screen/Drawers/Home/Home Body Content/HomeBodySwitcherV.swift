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
    }
}
