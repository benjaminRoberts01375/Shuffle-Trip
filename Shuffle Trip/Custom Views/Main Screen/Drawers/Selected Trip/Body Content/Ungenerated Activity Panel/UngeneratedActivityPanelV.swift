// Apr 16, 2023
// Ben Roberts

import SwiftUI

struct UngeneratedActivityPanelV: View {
    @StateObject var controller: UngeneratedActivityPaneVM
    
    init(tripLocations: TripLocations, activity: Activity, editingTracker: EditingTrackerM) {
        self._controller = StateObject(wrappedValue: UngeneratedActivityPaneVM(tripLocations: tripLocations, activity: activity, editingTracker: editingTracker))
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Planned")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(controller.label)
            }
            Spacer()
            if controller.editingTracker.isEditingTrip {
                Button(action: {
                }, label: {
                    Image(systemName: "shuffle.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(Color(UIColor.systemBlue))
                        .font(Font.title.weight(.bold))
                })
                Button(action: {
                    controller.showTagPicker = true
                }, label: {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.orange)
                        .font(Font.title.weight(.bold))
                })
                Button(action: {
                    print("Delete")
                }, label: {
                    Image(systemName: "trash.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.red)
                        .font(Font.title.weight(.bold))
                })
            }
        }
        .onReceive(controller.activity.objectWillChange) {
            controller.generateLabel()
        }
        .onReceive(controller.editingTracker.objectWillChange) {
            controller.checkEditing()
        }
        .sheet(isPresented: $controller.showTagPicker) {
            TagNavigatorV(activity: controller.activity)
        }
    }
}
