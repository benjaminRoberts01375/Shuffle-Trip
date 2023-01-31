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
    @State var isShortCard: Bool = false
    private let minimumMapSpace: CGFloat = 200
    private let minimumShortCardSize: CGFloat = 300
    
    init(goFull: Binding<Bool>, height offset: CGFloat, snapPoints: [CGFloat], screenSize: CGSize, content: Content) {
        self._offset = State(initialValue: offset)                              // Pre-set values since offset and some others are needed before they can be setup
        self.content = content                                                  // Content to show on card
        self.viewModel = BottomDrawerVM(goFull: goFull, snapPoints: snapPoints) // Initialize the view model
        isShortCard(width: screenSize.width)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Color.black
                    .opacity(backgroundDim / 2)
                    .allowsHitTesting(false)
                    .ignoresSafeArea(.all)
                    VStack {                                // The drawer itself
                        Capsule()                           // Grabber
                            .fill(Color.secondary)          // Dynamic color for dark/light mode
                            .opacity(0.5)
                            .frame(width: 50, height: 5)    // Roughly the same size as most apps
                            .padding(10)
                        content                             // Content passed in to show
                        Spacer()                            // Shove all content to the top
                    }
                    .frame(maxWidth: isShortCard ? minimumShortCardSize : 1000, minHeight: geometry.size.height, idealHeight: geometry.size.height, maxHeight: geometry.size.height)
                    .background(BlurView(style: .systemUltraThinMaterial, opacity: backgroundDim))  // Set frosted background
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .offset(y: geometry.size.height - offset)                                       // Lower offset = lower on screen
                    .onChange(of: viewModel.goFull) { value in                                      // Is only called when goFull changes
                        if value {                                                                  // If goFull, then bounce up to max size
                            withAnimation(.linear(duration: 0.2)) {
                                offsetCache = offset                                                // Cache where card was previously placed
                                offset = viewModel.snapPoints.max()!
                                setBackgroundOpacity()
                            }
                        }
                        else {
                            withAnimation (.interactiveSpring(response: 0.35, dampingFraction: 0.75)) {
                                offset = offsetCache                                                // Restore to previous position
                                setBackgroundOpacity()
                            }
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
                    .onChange(of: viewModel.snapPoints) { value in
                        isShortCard(width: geometry.size.width) // Is there enough space to show the map plus the card side-by-side?
                        let distances = viewModel.snapPoints.map{abs(offset - $0)}
                        offset = viewModel.snapPoints[distances.firstIndex(of: distances.min()!)!]  // Find closest height and set it
                        withAnimation(.linear) {
                            setBackgroundOpacity()
                        }
                    }
                    .onAppear() {
                        isShortCard(width: geometry.size.width) // Is there enough space to show the map plus the card side-by-side?
                    }
            }
        }
        .edgesIgnoringSafeArea([.top, .bottom])
    }
    
    public func setBackgroundOpacity() {
        let fadeAtPercent: CGFloat = 0.75
        let maxValue = viewModel.snapPoints.max()!
        backgroundDim = isShortCard ? 0.0 : (offset - maxValue * fadeAtPercent) / (maxValue * (1 - fadeAtPercent))
    }
    
    func isShortCard(width: CGFloat) {
        isShortCard  = width - minimumShortCardSize >= minimumMapSpace
    }
}

struct BottomDrawer_Previews: PreviewProvider {
    static var previews: some View {
        BottomDrawer(goFull: .constant(false), height: 200, snapPoints: [200, 500, 800], screenSize: CGSize(width: 375, height: 724), content: Text("Hello World"))
    }
}
