// Jan 18, 2023
// Ben Roberts

import SwiftUI

// Content: Generic type that conforms to view
struct BottomDrawer<Content: View>: View {
    @StateObject var controller: BottomDrawerVM<Content>
    @Environment(\.colorScheme) var colorScheme
    
    /// Default values for the capsule shown at the top of the drawer
    enum CapsuleProperties: Double {
        case opacity = 0.5
        case width = 50
        case height = 5
        case topPadding = 10
    }
    
    enum DrawerProperties: Double {
        case cornerRadius = 12
        case shadowDistance = 3
        case heightMultiplierBuffer = 1.1
        case backgroundFadeAmount = 0.5
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                Color.black                                                                             // Background fade when card is brought up
                    .opacity(controller.fadePercent * DrawerProperties.backgroundFadeAmount.rawValue)
                    .allowsHitTesting(false)
                    .ignoresSafeArea(.all)
                VStack {                                // The drawer itself
                    Capsule()                           // Grabber
                        .fill(Color.secondary)          // Dynamic color for dark/light mode
                        .opacity(CapsuleProperties.opacity.rawValue)
                        .frame(width: CapsuleProperties.width.rawValue, height: CapsuleProperties.height.rawValue)
                        .padding(.top, CapsuleProperties.topPadding.rawValue)
                    controller.content                  // Content passed in to show
                    Spacer()                            // Shove all content to the top
                }
                .frame(
                    maxWidth: controller.isShortCard ? controller.minimumShortCardSize : geometry.size.width,
                    minHeight: geometry.size.height * DrawerProperties.heightMultiplierBuffer.rawValue
                )
                .background(BlurView(style: .systemUltraThinMaterial, opacity: controller.fadePercent)) // Set frosted background
                .cornerRadius(DrawerProperties.cornerRadius.rawValue)
                .shadow(radius: DrawerProperties.shadowDistance.rawValue)
                .offset(
                    x: controller.isShortCard ? controller.offset.width : 0,                            // Higher offset = more left on screen
                    y: geometry.size.height - controller.offset.height                                  // Higher offset = higher on screen
                )
                .onAppear {
                    controller.IsShortCard(dimensions: geometry.size)                                   // Determine width of card
                }
                .gesture(
                    DragGesture()                                                                       // Drag controller
                        .onChanged { value in                                                           // User is dragging
                            controller.Drag(value: value)
                        }
                        .onEnded { _ in                                                                 // User finished dragging
                            controller.SnapToPoint()
                        }
                )
                .onChange(of: geometry.size) { size in                                                  // Screen dimensions changed (rotated)
                    controller.IsShortCard(dimensions: size)
                }
            }
        }
        .edgesIgnoringSafeArea([.bottom])
    }
}

struct BottomDrawer_Previews: PreviewProvider {
    static var previews: some View {
        BottomDrawer(controller: BottomDrawerVM(content: SearchBar(userIsSearching: SearchTracker()), snapPoints: [150, 1 / 2, 0.925], goFull: SearchTracker()))
    }
}
