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
    init(activity: Activity, index: Int) {
        self._controller = StateObject(wrappedValue: ActivityPaneVM(activity: activity, index: index))
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(content: {
                HStack {
                    Image(systemName: "\(controller.index).circle.fill")            // Using an invisible index bubble as a spacer
                        .opacity(0)
                        .disabled(true)
                        .allowsHitTesting(false)
                    Text("\(controller.activity.businesses[0].location.city ?? ""), \(controller.activity.businesses[0].location.state ?? "")") // Show city and state of activity
                        .font(.caption)
                        .padding(0)
                    Spacer()
                }
                Divider()
                BigButtonList()                                                     // Large buttons for almost any activity
                Divider()
                    .padding(.top, 18)
            }, label: {
                HStack {
                    Image(systemName: "\(controller.index).circle.fill")            // Index of the activity
                        .symbolRenderingMode(.hierarchical)
                    Text("\(controller.activity.businesses[0].name)")               // Name of the business
                        .multilineTextAlignment(.leading)
                }
                .foregroundColor(.primary)
                .padding(.top, 12)
            })
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
                .frame(width: 75, height: 55)
                .foregroundColor(.white)
                .background(highlighted ? .blue : Color.secondary)
                .cornerRadius(10)
            })
        }
    }
    
    /// A list of large buttons shared between activities
    struct BigButtonList: View {
        var body: some View {
            HStack {
                Spacer()
                Spacer()
                BigButton(                                  // Navigate button
                    action: {  },
                    image: Image(systemName: "map.fill"),
                    label: "Navigate",
                    highlighted: true
                )
                Spacer()
                BigButton(                                  // Shuffle activity button
                    action: {  },
                    image: Image(systemName: "shuffle"),
                    label: "Shuffle",
                    highlighted: false
                )
                Spacer()
                BigButton(                                  // Remove activity button
                    action: {  },
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
