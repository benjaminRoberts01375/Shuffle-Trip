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
                    lookAroundAction: { print("look around") },
                    openMapsAction: { print("open maps") },
                    shuffleAction: { controller.shuffleActivity() },
                    removeActivityAction: { controller.removeActivity() }
                )  // Large buttons for almost any activity
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
        .onReceive(controller.tripLocations.objectWillChange) {
            controller.generateIndex()
        }
    }
    
    struct BigButton: View {
        var action: () -> Void
        var image: Image
        var label: String
        var highlighted: Bool
        
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
        var lookAroundAction: () -> Void
        var openMapsAction: () -> Void
        var shuffleAction: () -> Void
        var removeActivityAction: () -> Void
        
        var body: some View {
            HStack {
                Spacer()
                Spacer()
                BigButton(                                  // Look around button
                    action: lookAroundAction,
                    image: Image(systemName: "binoculars.fill"),
                    label: "Look Around",
                    highlighted: false
                )
                BigButton(                                  // Navigate button
                    action: openMapsAction,
                    image: Image(systemName: "map.fill"),
                    label: "Navigate",
                    highlighted: true
                )
                Spacer()
                BigButton(                                  // Shuffle activity button
                    action: shuffleAction,
                    image: Image(systemName: "shuffle"),
                    label: "Shuffle",
                    highlighted: false
                )
                Spacer()
                BigButton(                                  // Remove activity button
                    action: removeActivityAction,
                    image: Image(systemName: "trash.fill"),
                    label: "Remove",
                    highlighted: false
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
