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
                    Text("\(controller.activity.businesses?[0].location.city ?? ""), \(controller.activity.businesses?[0].location.state ?? "")") // Show city and state of activity
                        .font(.caption)
                        .padding(0)
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
                if controller.lookAroundPossible {
                    LookAroundV(location: $controller.lookAroundLocation, showLookAroundView: $controller.showLookAround)
                    .frame(minHeight: 150)
                    .cornerRadius(7)
                }
                Divider()
                    .padding(.top, 18)
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

struct ActivityPaneV_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
