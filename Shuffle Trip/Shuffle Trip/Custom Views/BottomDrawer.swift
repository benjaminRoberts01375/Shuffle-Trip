// Jan 18, 2023
// Ben Roberts

import SwiftUI

// Content: Generic type that conforms to view
struct BottomDrawer<Content: View>: View {
    @State var offset: CGFloat
    @State var offsetCache:CGFloat = 0
    @Binding var goFull: Bool
    @State private var previousDrag: CGFloat
    @Environment(\.colorScheme) var colorScheme
    let snapPoints: [CGFloat]
    var content: Content
    
    init(goFull: Binding<Bool>, height offset: CGFloat, snapPoints: [CGFloat], content: Content) {
        self._goFull = goFull
        self._offset = State(initialValue: offset) // Pre-set values since offset and some others are needed before they can be setup
        self._previousDrag = State(initialValue: 0)
        self.snapPoints = snapPoints
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack { // The drawer itself
                    Capsule() // Grabber
                        .fill(Color.secondary)
                        .opacity(0.5)
                        .frame(width: 50, height: 5)
                        .padding(10)
                    content // Content passed in to show
                    Spacer() // Shove all content to the top
                }
                
                .frame(width: geometry.size.width, height: geometry.size.height) // Fill the outer VStack
                .background(BlurView(style: .systemUltraThinMaterial))
                .cornerRadius(12)
                .shadow(radius: 3)
                .offset(y: geometry.size.height - offset)
                .onChange(of: goFull) { value in
                    withAnimation (.interactiveSpring(response: 0.25, dampingFraction: 0.75)) {
                        if value {
                            offsetCache = offset
                            offset = snapPoints.max() ?? 500
                            return
                        }
                        offset = offsetCache
                    }
                }
                .gesture( // Drag controller
                    DragGesture()
                        .onChanged { value in
                            offset -= value.translation.height - previousDrag // Inverted to allow for smaller values to be at bottom
                            previousDrag = value.translation.height // Save current drag distance to allow for relative positioning on the line above
                        }
                        .onEnded { value in
                            if snapPoints.count > 0 {
                                withAnimation (.interactiveSpring(response: 0.2, dampingFraction: 1/2)) { // Bounce once
                                    if goFull {
                                        offset = snapPoints.max() ?? 500
                                    }
                                    else {
                                        let distances = snapPoints.map{abs(offset - $0)} // Figure out how far away sheet is from provided heights
                                        offset = snapPoints[distances.firstIndex(of: distances.min() ?? 500) ?? 0] // Find closest height and set it
                                    }
                                }
                            }
                            previousDrag = 0 // Reset dragging
                        }
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct BottomDrawer_Previews: PreviewProvider {
    static var previews: some View {
        BottomDrawer(goFull: .constant(false), height: 200, snapPoints: [200, 500, 800], content: Text("Hello World"))
    }
}
