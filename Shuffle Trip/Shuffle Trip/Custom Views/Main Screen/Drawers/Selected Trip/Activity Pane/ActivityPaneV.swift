// Mar 20, 2023
// Ben Roberts

import SwiftUI

struct ActivityPaneV: View {
    
    @StateObject var controller: ActivityPaneVM
    
    init(activity: Activity, index: Int) {
        self._controller = StateObject(wrappedValue: ActivityPaneVM(activity: activity, index: index))
    }
    
    var body: some View {
        DisclosureGroup(content: {
            VStack {
                HStack {
                    BigButton(
                        action: {  },
                        image: Image(systemName: "map.fill"),
                        label: "Navigate",
                        highlighted: true
                    )
                    BigButton(
                        action: {  },
                        image: Image(systemName: "shuffle"),
                        label: "Shuffle",
                        highlighted: false
                    )
                    BigButton(
                        action: {  },
                        image: Image(systemName: "trash.fill"),
                        label: "Remove",
                        highlighted: false
                    )
                }
            }
        }, label: {
            HStack {
                Image(systemName: "\(controller.index).circle.fill")
                Text("\(controller.activity.businesses[0].name)")
            }
            .foregroundColor(.primary)
        })
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
                        .font(.title)
                    Text(label)
                        .font(.caption)
                }
                .frame(width: 75, height: 60)
                .foregroundColor(.white)
                .background(highlighted ? .blue : Color.secondary)
                .cornerRadius(10)
            })
        }
    }
}

struct ActivityPaneV_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
