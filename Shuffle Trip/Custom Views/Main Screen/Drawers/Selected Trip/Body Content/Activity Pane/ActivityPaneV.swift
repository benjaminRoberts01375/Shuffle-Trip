// Mar 20, 2023
// Ben Roberts

import SwiftUI

struct ActivityPaneV: View {
    /// Controller for the activity pane
    @StateObject var controller: ActivityPaneVM
    
    /// Initializer for the Activity pane
    /// - Parameters:
    ///   - activity: Activity to display information for
    ///   - index: Index of the activity within the trip
    init(activity: Activity, tripLocations: TripLocations) {
        self._controller = StateObject(wrappedValue: ActivityPaneVM(activity: activity, tripLocations: tripLocations))
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(content: {
                HStack {
                    Image(systemName: "\(controller.index).circle.fill")            // Using an invisible index bubble as a spacer
                        .opacity(0)
                        .disabled(true)
                        .allowsHitTesting(false)
                    Spacer()
                    VStack {
                        HStack {
                            Text("\(controller.activity.businesses?[0].location.city ?? ""), \(controller.activity.businesses?[0].location.state ?? "")") // Show city and state of activity
                                .font(.caption)
                                .padding(0)
                            Spacer()
                        }
                        HStack {
                            Image(String(format: "%g", controller.activity.businesses?[0].rating ?? 0))
                                .resizable()
                                .scaledToFit()
                                .aspectRatio(contentMode: .fit)
                                .frame(minHeight: 5, maxHeight: 20)
                                .accessibilityLabel("Ratings: \(String(format: "%g", controller.activity.businesses?[0].rating ?? 0))")
                            Text("/ \(String(controller.activity.businesses?[0].reviewCount == 0 ? "No" : String((controller.activity.businesses?[0].reviewCount ?? 0)))) \(controller.activity.businesses?[0].reviewCount == 1 ? "review" : "reviews")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if controller.activity.businesses?[0].price != nil {
                                Spacer()
                                Text("\(controller.activity.businesses?[0].price ?? "")")
                            }
                            Spacer()
                            if controller.activity.businesses?[0] != nil {
                                Link(destination: URL(string: controller.activity.businesses?[0].url ?? "")!) {
                                    Image("yelp_logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 20)
                                        .accessibilityLabel("Yelp Logo")
                                }
                            }
                        }
                    }
                    Spacer()
                }
                Divider()
                
                BigButtonList(
                    openMapsAction: { controller.openMaps() },
                    shuffleAction: { controller.shuffleActivity() },
                    editTagsAction: { controller.showTagSelector = true },
                    removeActivityAction: { controller.removeActivity() },
                    allowShuffle: $controller.allowShuffle
                )  // Large buttons for almost any activity
                .padding(6)
                .background(BlurView(style: .systemThinMaterial, opacity: 0.2))
                .cornerRadius(6)
                .shadow(color: .primary.opacity(0.2), radius: 2)
                .padding(.vertical, 3)
                
                if controller.lookAroundPossible {
                    LookAroundV(location: $controller.lookAroundLocation, showLookAroundView: $controller.showLookAround)
                        .frame(minHeight: 150)
                        .cornerRadius(7)
                        .padding(.vertical, 3)
                }
                else {
                    if controller.activity.businesses?[0].imageUrl ?? "" != "" {
                        VStack {
                            AsyncImage(
                                url: URL(string: controller.activity.businesses?[0].imageUrl ?? ""),
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 150)
                                },
                                placeholder: {
                                    HStack {
                                        Text("Loading image ")
                                            .foregroundColor(.secondary)
                                        ProgressView()
                                    }
                                }
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .background(BlurView(style: .systemThinMaterial, opacity: 0.2))
                        .cornerRadius(6)
                        .shadow(color: .primary.opacity(0.2), radius: 2)
                        .padding(.vertical, 3)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Address")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if  controller.activity.businesses?[0].location.address1 ?? "" != "" &&
                            controller.activity.businesses?[0].location.city ?? "" != "" &&
                            controller.activity.businesses?[0].location.zipCode ?? "" != "" &&
                            controller.activity.businesses?[0].location.state ?? "" != "" &&
                            controller.activity.businesses?[0].location.country ?? "" != "" {
                        Button(action: {
                            controller.openMaps()
                        }, label: {
                            VStack(alignment: .leading) {
                                Text("\(controller.activity.businesses?[0].location.address1 ?? "")")
                                    .foregroundColor(.blue)
                                Text("\(controller.activity.businesses?[0].location.city ?? ""), \(controller.activity.businesses?[0].location.state ?? "") \(controller.activity.businesses?[0].location.zipCode ?? "")")
                                    .foregroundColor(.blue)
                                Text("\(controller.activity.businesses?[0].location.country ?? "")")
                                    .foregroundColor(.blue)
                            }
                        })
                    }
                    else {
                        Text("None provided.")
                    }
                    Divider()
                    Text("Phone")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if controller.activity.businesses?[0].phone ?? "" != "" {
                        Button(action: {
                            guard let url = URL(string: "tel://\((controller.activity.businesses?[0].phone)!)") else { return }
                            UIApplication.shared.open(url)
                        }, label: {
                            Text(controller.activity.businesses?[0].displayPhone ?? "")
                        })
                    }
                    else {
                        Text("None provided.")
                    }
                    Divider()
                    Text("Website")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if controller.activity.businesses?[0].url ?? "" != "" {
                        Link(destination: URL(string: controller.activity.businesses?[0].url ?? "")!) {
                            Text(((controller.activity.businesses?[0].url ?? "").split(separator: "www.").last?.split(separator: "?").first ?? ""))
                                .foregroundColor(.blue)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    else {
                        Text("None provided")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(6)
                .background(BlurView(style: .systemThinMaterial, opacity: 0.2))
                .cornerRadius(6)
                .shadow(color: .primary.opacity(0.2), radius: 2)
                .padding(.vertical, 3)
            }, label: {
                HStack {
                    Image(systemName: "\(controller.index).circle.fill")            // Index of the activity
                        .symbolRenderingMode(.hierarchical)
                    Text("\(controller.activity.businesses?[0].name ?? "")")        // Name of the business
                        .multilineTextAlignment(.leading)
                }
                .foregroundColor(.primary)
            })
        }
        .sheet(isPresented: $controller.showTagSelector) {
            TagNavigatorV(activity: controller.activity)
        }
        .onReceive(controller.tripLocations.objectWillChange) {
            controller.generateIndex()
            controller.checkValidActivity()
            controller.checkLookAround()
        }
    }
    
    struct BigButton: View {
        var action: () -> Void
        var image: Image
        var label: String
        var highlighted: Bool
        @Binding var enabled: Bool
        
        var body: some View {
            Button(action: {
                action()
            }, label: {
                VStack {
                    image
                        .font(.title3)
                    Text(label)
                        .font(.caption2)
                }
                .frame(width: 65, height: 55)
                .foregroundColor(highlighted ? .white : .blue)
                .background(highlighted ? .blue : Color(UIColor.quaternarySystemFill))
                .cornerRadius(10)
            })
            .disabled(!enabled)
            .opacity(enabled ? 1 : 0.5)
        }
    }
    
    /// A list of large buttons shared between activities
    struct BigButtonList: View {
        var openMapsAction: () -> Void
        var shuffleAction: () -> Void
        var editTagsAction: () -> Void
        var removeActivityAction: () -> Void
        @Binding var allowShuffle: Bool
        
        var body: some View {
            HStack {
                Spacer()
                Spacer()
                BigButton(                                  // Navigate button
                    action: openMapsAction,
                    image: Image(systemName: "map.fill"),
                    label: "Navigate",
                    highlighted: true,
                    enabled: .constant(true)
                )
                Spacer()
                BigButton(                                  // Shuffle activity button
                    action: shuffleAction,
                    image: Image(systemName: "shuffle"),
                    label: "Shuffle",
                    highlighted: false,
                    enabled: $allowShuffle
                )
                Spacer()
                BigButton(
                    action: editTagsAction,
                    image: Image(systemName: "tag.fill"),
                    label: "Edit tags",
                    highlighted: false,
                    enabled: .constant(true)
                )
                BigButton(                                  // Remove activity button
                    action: removeActivityAction,
                    image: Image(systemName: "trash.fill"),
                    label: "Remove",
                    highlighted: false,
                    enabled: .constant(true)
                )
                Spacer()
                Spacer()
            }
        }
    }
}
