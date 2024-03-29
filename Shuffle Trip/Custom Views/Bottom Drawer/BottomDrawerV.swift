// Jan 18, 2023
// Ben Roberts

import SwiftUI

// Content: Generic type that conforms to view
struct BottomDrawer<Content: DrawerView>: View {
    @StateObject var controller: BottomDrawerVM<Content>
    @State var keyboardHeight: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    init(content: Content, snapPoints: [CGFloat]) {
        self._controller = StateObject(wrappedValue: BottomDrawerVM(content: content, snapPoints: snapPoints))
        self._keyboardHeight = State(initialValue: 0)
    }
    
    /// Default values for the capsule shown at the top of the drawer
    enum CapsuleProperties: Double {
        case opacity = 0.5
        case width = 50
        case height = 5
        case topPadding = 10
    }
    /// Default values for the drawer itself
    enum DrawerProperties: Double {
        case cornerRadius = 12
        case shadowDistance = 3
        case heightMultiplierBuffer = 1.1
        case backgroundFadeAmount = 0.5
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                Color.black                                                                                 // Background fade when card is brought up
                    .opacity(controller.backgroundFadePercent * DrawerProperties.backgroundFadeAmount.rawValue)
                    .allowsHitTesting(false)
                    .ignoresSafeArea(.all)
                VStack {                                                                                    // The drawer itself
                    Capsule()                                                                               // Grabber
                        .fill(Color.secondary)                                                              // Dynamic color for dark/light mode
                        .opacity(CapsuleProperties.opacity.rawValue)
                        .frame(width: CapsuleProperties.width.rawValue, height: CapsuleProperties.height.rawValue)
                        .padding(.top, CapsuleProperties.topPadding.rawValue)
                    
                    controller.content.header                                                               // Header Content
                        .padding(.horizontal, 7)
                    
                    VStack {
                        ScrollView {
                            controller.content.body                                                         // Content passed in to show
                                .padding(.horizontal, 7)
                                .frame(width: controller.isShortCard ? controller.minimumShortCardSize : geometry.size.width)
                            Color.clear
                                .frame(height: keyboardHeight)
                        }
                    }
                    .scrollDisabled(controller.offset.height < geometry.size.height / 4)
                    .background(BlurView(style: .systemUltraThinMaterial, opacity: 0.0))
                    .cornerRadius(18)
                    .shadow(radius: 2)
                    .opacity(controller.foregroundFadePercent)
                    
                }
                .frame(
                    width: controller.isShortCard ? controller.minimumShortCardSize : geometry.size.width,
                    height: controller.offset.height
                )
                .background(BlurView(style: .systemUltraThinMaterial, opacity: controller.backgroundFadePercent)) // Set frosted background
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
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                    controller.ToggleMaxOffset(isFull: true)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                    controller.ToggleMaxOffset(isFull: false)
                }
            }
        }
        .edgesIgnoringSafeArea([.bottom])
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in  // Add observer for keeping track of keyboard raising
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }                    // Convert coordinates into a CGRect
                self.keyboardHeight = keyboardFrame.height                                                                                              // Save keyboard height
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in             // Add observer for keeping track of keyboard hiding
                self.keyboardHeight = 0                                                                                                                 // Keyboard hid, set back to zero
            }
            controller.SnapToPoint()
        }
    }
}

struct BottomDrawer_Previews: PreviewProvider {
    
    struct Preview: DrawerView {
        var header: some View {
            EmptyView()
        }
        
        var body: some View {
            VStack {
                Text("Body")
            }
        }
    }
    
    static var previews: some View {
        ZStack {
            RegionSelector(                     // Map
                logoPosition: 125,
                region: RegionDetails(),
                tripLocations: TripLocations()
            )
            
            BottomDrawer(                       // Drawer
                content: Preview(),
                snapPoints: [150, 1 / 2, 0.925]
            )
        }
        .ignoresSafeArea()
    }
}
