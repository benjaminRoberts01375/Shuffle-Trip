// Feb 17, 2023
// Ben Roberts

import SwiftUI

struct SelectedTripV: View {
    @StateObject var controller: SelectedTripVM
    var body: some View {
        VStack(alignment: .leading) {
            if controller.selectedTrip != nil {
                HStack {
                    TextField("Name of trip", text: $controller.tripName)
                        .font(Font.title.weight(.bold))
                        .disabled(!controller.isEditingTrip)
                    Spacer()
                    
                    if controller.isEditingTrip {
                        HStack {
                            Button(action: {                            // Editing - check mark
                                withAnimation {
                                    controller.isEditingTrip = false
                                }
                            }, label: {
                                Image(systemName: "checkmark.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.green)
                                    .font(Font.title.weight(.bold))
                            })
                            Button(action: {                            // Editing - x mark
                                withAnimation {
                                    controller.isEditingTrip = false
                                }
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.red)
                                    .font(Font.title.weight(.bold))
                            })
                        }
                        .transition(.opacity)
                    }
                    else if controller.shuffleConfirmation {
                        HStack {
                            Text("Confirm")
                                .font(Font.headline.weight(.bold))
                            Button(action: {                            // Confirm shuffle - No
                                withAnimation {
                                    controller.shuffleConfirmation = false
                                }
                            }, label: {
                                Image(systemName: "arrow.uturn.backward.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.green)
                                    .font(Font.title.weight(.bold))
                            })
                            Button(action: {                            // Confirm shuffle - Yes
                                controller.selectedTrip!.ShuffleTrip()
                                withAnimation {
                                    controller.shuffleConfirmation = false
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
                    else {
                        HStack {
                            Button(action: {                            // Share
                            }, label: {
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.primary)
                                    .font(Font.title.weight(.bold))
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
                            
                            Button(action: {                            // Shuffle
                                withAnimation {
                                    controller.shuffleConfirmation = true
                                }
                            }, label: {
                                Image(systemName: "shuffle.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.primary)
                                    .font(Font.title.weight(.bold))
                            })
                            
                            Button(action: {                            // Close card button
                                controller.tripLocations.SelectTrip()
                            }, label: {
                                Image(systemName: "chevron.down.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(Color.primary)
                                    .font(Font.title.weight(.bold))
                            })
                        }
                        .transition(.opacity)
                    }
                }
                .onAppear {
                    controller.tripName = controller.selectedTrip!.name
                }
                .onSubmit {
                    controller.selectedTrip?.name = controller.tripName
                    withAnimation {
                        controller.isEditingTrip = false
                    }
                }
                .onTapGesture {
                    withAnimation {
                        controller.isEditingTrip = true
                    }
                }
                .shadow(color: .black.opacity(0.25), radius: 2)
                .cornerRadius(6)
                Divider()
                List {
                    Section("Activities") {
                        ForEach(Array(controller.selectedTrip!.activityLocations.enumerated()), id: \.1.self) { index, activity in
                            DisclosureGroup(
                                content: {
                                    Text(activity.businesses[0].location.address1)
                                }, label: {
                                    HStack {
                                        Image(systemName: "\(index + 1).circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(Color.secondary)
                                            .font(Font.title2.weight(.regular))
                                        Text(activity.businesses[0].name)
                                    }
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
