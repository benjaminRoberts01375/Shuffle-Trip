// Jan 18, 2023
// Ben Roberts

import SwiftUI

// Content: Generic type that conforms to view
struct BottomDrawer<Content: View>: View {
    @StateObject var controller: BottomDrawerVM<Content>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                Color.black                                 // Background fade when card is brought up
                    .opacity(controller.fadePercent / 2)
                    .allowsHitTesting(false)
                    .ignoresSafeArea(.all)
                    VStack {                                // The drawer itself
                        Capsule()                           // Grabber
                            .fill(Color.secondary)          // Dynamic color for dark/light mode
                            .opacity(0.5)
                            .frame(width: 50, height: 5)    // Roughly the same size as most apps
                            .padding(.top, 10)
                        controller.content                  // Content passed in to show
                        Spacer()                            // Shove all content to the top
                    }
                    .frame(maxWidth: controller.isShortCard ? controller.minimumShortCardSize : 1000, minHeight: geometry.size.height, idealHeight: geometry.size.height, maxHeight: geometry.size.height)
                    .background(BlurView(style: .systemUltraThinMaterial, opacity: controller.fadePercent)) // Set frosted background
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .offset(y: geometry.size.height - controller.offset)                                    // Lower offset = lower on screen
                    .onAppear() {
                        controller.IsShortCard(width: geometry.size.width)                                  // Determine width of card
                    }
                    .gesture (
                        DragGesture()                                   // Drag controller
                        .onChanged { value in                           // User is dragging
                                controller.Drag(value: value)
                            }
                            .onEnded { value in                         // User finished dragging
                                controller.SnapToPoint()
                            }
                    )
                    .onChange(of: controller.snapPoints[1]) { size in                                                  // Screen dimensions changed (rotated)
                        controller.IsShortCard(width: geometry.size.width)
                    }
            }
        }
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}

struct BottomDrawer_Previews: PreviewProvider {
    static var previews: some View {
        BottomDrawer(controller: BottomDrawerVM(content: SearchBar(userIsSearching: SearchTracker()), snapPoints: [150, 400, 800], goFull: SearchTracker()))
    }
}
