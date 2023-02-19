// Feb 17, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripV: View {
    @StateObject var controller: SelectedTripVM
    @State private var selectedItem: TripLocation.Activities?
    @State private var isExpanded = false
    @State var tripName: String = ""
    @State var isEditingTrip: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            if controller.selectedTrip != nil {
                HStack {
                    TextField("Name of trip", text: $tripName)
                        .disabled(!isEditingTrip)
                    Spacer()
                    
                    if isEditingTrip {
                        HStack {
                            Button(action: {                            // Editing - check mark
                                withAnimation {
                                    isEditingTrip = false
                                }
                            }, label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.green)
                            })
                            Button(action: {                            // Editing - x mark
                                withAnimation {
                                    isEditingTrip = false
                                }
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.red)
                            })
                        }
                        .transition(.opacity)
                    }
                    else {
                        HStack {
                            Button(action: {                            // Share
                            }, label: {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.primary)
                            })
//                            Button(action: {                            // Edit trip
//                                withAnimation {
//                                    isEditingTrip = true
//                                }
//                            }, label: {
//                                Image(systemName: "pencil.circle.fill")
//                                    .symbolRenderingMode(.hierarchical)
//                                    .foregroundStyle(Color.primary)
//                            })
                            Button(action: {
                            }, label: {
                                Image(systemName: "shuffle.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.primary)
                            })
                            Button(action: {                            // Close card button
                                controller.tripLocations.SelectTrip()
                            }, label: {
                                Image(systemName: "chevron.down.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.primary)
                            })
                        }
                        .transition(.opacity)
                    }
                }
                .onAppear {
                    tripName = controller.selectedTrip!.name
                }
                .onSubmit {
                    controller.selectedTrip?.name = tripName
                    isEditingTrip = false
                }
                .onTapGesture {
                    isEditingTrip = true
                }
                .font(Font.title.weight(.bold))
                .shadow(color: .black.opacity(0.25), radius: 2)
                .cornerRadius(6)
                Divider()
                List {
                    Section("Activities") {
                        ForEach(controller.selectedTrip!.activityLocations, id: \.self) { item in
                            DisclosureGroup(
                                content: {
                                    Text(item.businesses[0].location.address1)
                                }, label: {
                                    Text(item.businesses[0].name)
                                }
                            )
                            .listRowBackground(BlurView(style: .systemMaterial, opacity: 0))
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.clear)
            }
        }
    }
}
