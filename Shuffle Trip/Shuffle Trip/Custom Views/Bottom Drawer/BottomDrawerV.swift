// Jan 18, 2023
// Ben Roberts

import SwiftUI

// Content: Generic type that conforms to view
struct BottomDrawer<Content: View>: View {
    @State var offset: CGFloat
    @State var previousDrag: CGFloat = 0
    @State var offsetCache: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    @State var backgroundDim: Double = 0.0
    var content: Content
    var viewModel: BottomDrawerVM<Content>
    
    init(goFull: Binding<Bool>, height offset: CGFloat, snapPoints: [CGFloat], content: Content) {
        self._offset = State(initialValue: offset)                              // Pre-set values since offset and some others are needed before they can be setup
        self.content = content                                                  // Content to show on card
        self.viewModel = BottomDrawerVM(goFull: goFull, snapPoints: snapPoints) // Initialize the view model
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black
                    .opacity(backgroundDim / 2)
                    .allowsHitTesting(false)
                VStack {                                // The drawer itself
                    Capsule()                           // Grabber
                        .fill(Color.secondary)          // Dynamic color for dark/light mode
                        .opacity(0.5)
                        .frame(width: 50, height: 5)    // Roughly the same size as most apps
                        .padding(10)
                    content                             // Content passed in to show
                    Spacer()                            // Shove all content to the top
                }
                .frame(width: geometry.size.width, height: geometry.size.height)                // Fill the outer VStack
                .background(BlurView(style: .systemUltraThinMaterial, opacity: backgroundDim))  // Set frosted background
                .cornerRadius(12)
                .shadow(radius: 3)
                .offset(y: geometry.size.height - offset)                                       // Lower offset = lower on screen
                .onChange(of: viewModel.goFull) { value in                                      // Is only called when goFull changes
                    withAnimation (.interactiveSpring(response: 0.3, dampingFraction: 0.75)) {
                        if value {                                  // If goFull, then bounce up to max size
                            offsetCache = offset
                            offset = viewModel.snapPoints.max()!
                        }
                        else {
                            offset = offsetCache                    // Otherwise, restore to previous position
                        }
                        setBackgroundOpacity()
                    }
                }
                .gesture (                                                                                          // Drag controller
                    DragGesture()
                        .onChanged { value in
                            offset -= value.translation.height - previousDrag                                       // Inverted to allow for smaller values to be at bottom
                            previousDrag = value.translation.height                                                 // Save current drag distance to allow for relative positioning on the line above
                            setBackgroundOpacity()
                        }
                        .onEnded { value in
                            if viewModel.snapPoints.count > 0 {
                                withAnimation (.interactiveSpring(response: 0.2, dampingFraction: 1/2)) {
                                    let distances = viewModel.snapPoints.map{abs(offset - $0)}                      // Figure out how far away sheet is from provided heights
                                    if viewModel.goFull {
                                        offset = viewModel.snapPoints.max()!
                                    }
                                    else {
                                        offset = viewModel.snapPoints[distances.firstIndex(of: distances.min()!)!]  // Find closest height and set it
                                    }
                                    setBackgroundOpacity()
                                }
                            }
                            previousDrag = 0 // Reset dragging
                        }
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func setBackgroundOpacity() {
        let fadeAtPercent: CGFloat = 0.85
        let maxValue = viewModel.snapPoints.max()!
        backgroundDim = (offset - maxValue * fadeAtPercent) / (maxValue * (1 - fadeAtPercent))
    }
}

struct BottomDrawer_Previews: PreviewProvider {
    static var previews: some View {
        BottomDrawer(goFull: .constant(false), height: 200, snapPoints: [200, 500, 800], content: Text("Hello World"))
    }
}
