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
                                    .foregroundStyle(Color.secondary)
                                    .font(Font.title.weight(.bold))
                            })
                            //                            Button(action: {                            // Edit trip
                            //                                withAnimation {
                            //                                    isEditingTrip = true
                            //                                }
                            //                            }, label: {
                            //                                Image(systemName: "pencil.circle.fill")
                            //                                    .symbolRenderingMode(.hierarchical)
                            //                                    .foregroundStyle(Color.secondary)
                            //                            })
                            
                            Button(action: {                            // Shuffle
                                withAnimation {
                                    controller.shuffleConfirmation = true
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
                .cornerRadius(6)
                Divider()
                ScrollView {
                    ForEach(Array(controller.selectedTrip!.activityLocations.enumerated()), id: \.1.self) { index, activity in
                        VStack(alignment: .leading) {
                            DisclosureGroup(
                                content: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            VStack(alignment: .leading) {
                                                Text("Address")
                                                    .font(.caption)
                                                    .fontWeight(.light)
                                                    .foregroundColor(Color.secondary)
                                                Text("\(activity.businesses[0].location.address1) \(activity.businesses[0].location.address2 ?? "") \(activity.businesses[0].location.address3 ?? "")")
                                                    .font(.body)
                                                    .fontWeight(.regular)
                                                    .foregroundColor(Color.primary)
                                                Text("\(activity.businesses[0].location.city), \(activity.businesses[0].location.state) \(activity.businesses[0].location.zipCode)")
                                                    .font(.body)
                                                    .fontWeight(.regular)
                                                    .foregroundColor(Color.primary)
                                                Text("\(activity.businesses[0].location.country)")
                                                    .font(.body)
                                                    .fontWeight(.regular)
                                                    .foregroundColor(Color.primary)
                                            }
                                            .padding(10)
                                            .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.5))
                                            .cornerRadius(10)
                                                VStack(alignment: .leading) {
                                                    Text("Ratings")
                                                        .font(.caption)
                                                        .fontWeight(.light)
                                                        .foregroundColor(Color.secondary)
                                                    HStack {
                                                        Image(systemName: "star.fill")
                                                            .symbolRenderingMode(.hierarchical)
                                                            .foregroundStyle(Color.secondary)
                                                            .font(.caption)
                                                            .fontWeight(.ultraLight)
                                                        Text("\(activity.businesses[0].rating)")
                                                            .font(.body)
                                                            .fontWeight(.regular)
                                                            .foregroundColor(Color.primary)
                                                        Text("/10")
                                                            .font(.caption)
                                                            .fontWeight(.light)
                                                            .foregroundColor(Color.secondary)
                                                    }
                                                    Text("\(activity.businesses[0].reviewCount) \(activity.businesses[0].reviewCount == 1 ? "review" : "reviews")")
                                                }
                                                .padding(10)
                                                .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.5))
                                                .cornerRadius(10)
                                        }
                                        AsyncImage(url: URL(string: controller.selectedTrip?.activityLocations[index].businesses[0].imageUrl ?? ""), scale: 5)
                                            .cornerRadius(10)
                                    }
                                }, label: {
                                    HStack {
                                        Image(systemName: "\(index + 1).circle.fill")
                                            .symbolRenderingMode(.hierarchical)
                                            .foregroundStyle(Color.secondary)
                                            .font(Font.title2.weight(.regular))
                                        Text(activity.businesses[0].name)
                                            .foregroundColor(Color.primary)
                                    }
                                }
                            )
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.5))
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
    }
}
