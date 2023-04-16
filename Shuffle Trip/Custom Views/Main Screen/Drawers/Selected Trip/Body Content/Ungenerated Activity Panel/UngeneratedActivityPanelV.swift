// Apr 16, 2023
// Ben Roberts

import SwiftUI

struct UngeneratedActivityPanelV: View {
    @StateObject var controller: UngeneratedActivityPaneVM
    
    init(activity: Activity) {
        self._controller = StateObject(wrappedValue: UngeneratedActivityPaneVM(activity: activity))
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
        .padding()
        .background(BlurView(style: .systemUltraThinMaterial, opacity: 0))
        .cornerRadius(7)
        .onReceive(controller.activity.objectWillChange) {
            controller.generateLabel()
        }
        .sheet(isPresented: $controller.showTagPicker) {
            TagNavigatorV(activity: controller.activity)
        }
    }
}
