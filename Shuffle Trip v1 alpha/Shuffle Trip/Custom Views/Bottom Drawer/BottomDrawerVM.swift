// Jan 27, 2023
// Ben Roberts

import SwiftUI

@MainActor class BottomDrawerVM<Content: DrawerView>: ObservableObject {
    /// Keeps track of if the drawer is operating in full width or partial width of the screen
    @Published var isShortCard: Bool = false
    /// A constatnt to determine the drawer's size
    private let defaultCardSize: CGFloat = 500
    /// Sets the horizontal snap points when in short card mode. There will always be one available.
    @Published var snapPointsX: [CGFloat] {
        didSet {
            if snapPointsX.isEmpty {
                snapPointsX = [defaultCardSize]
            }
        }}
    /// The raw snap points as passed in by other structs and classes. Some may be decimals/fractions for arbitrary measurements, or specific values
    private let rawSnapPointsY: [CGFloat]
    /// The snap points actually used by the drawer
    @Published var snapPointsY: [CGFloat] {
        didSet {
            if snapPointsY.isEmpty {
                snapPointsY = [defaultCardSize]
            }
        }}
    /// Height of the drawer, and horizontal position
    @Published var offset: CGSize {
        didSet {
            if offset.height == 0 {
                SnapToPoint()
            }
        }
    }
    /// Cache for the drawer's height in the event it must be temporarily resized
    private var offsetCache: CGFloat = 0
    /// The previous height of a drag gesture for keeping track of distance/velocity
    private var previousDrag: CGSize = CGSize(width: 0, height: 0)
    /// How much the background behind the drawer should fade as a percent
    @Published var backgroundFadePercent: Double = 0.0
    /// How much the body of the drawer should fade as a percent
    @Published var foregroundFadePercent: Double = 0.0
    /// Keep track if the drawer is supposed to be at full height
    private var isFull: Bool = false
    /// Content to show on the drawer
    @Published var content: Content
    
    /// Minimum width of the card when in the thinner mode
    public let minimumShortCardSize: CGFloat = 300
    /// How much of the map behind the drawer MUST be visible
    public let minimumMapSpace: CGFloat = 200
    
    /// A drawer that is capable of being dragged around by the user
    /// - Parameters:
    ///   - content: Content to display on the drawer (header and body via the DrawerView protocol)
    ///   - snapPoints: Positions to snap to. Values less than 1 are interpreted as percentages
    init(content: Content, snapPoints: [CGFloat]) {
        let ensuredSnapPoints = snapPoints.isEmpty ? [defaultCardSize] : snapPoints
        self.snapPointsY = snapPoints.isEmpty ? [defaultCardSize] : snapPoints
        self.rawSnapPointsY = snapPoints
        self.snapPointsX = [0]
        self.offset = CGSize(width: 0, height: ensuredSnapPoints[0])
        self.content = content
    }
    
    /// Recalculates the snap points based on height of the screen, and snaps the drawer.
    /// - Parameter dimensions: Dimensions of the screen, usually from a `GeometryReader.size`
    private func recalculateSnapPoints(dimensions: CGSize) {
        let minimumSnapDistance: CGFloat = 100
        snapPointsY = rawSnapPointsY.map { $0 < 1 ? dimensions.height * $0 : $0 }
        
        // Remove any snap point that is not one of the ends, and is within 100pt of another snap point
        for point in snapPointsY.dropFirst().dropLast() {
            guard let snapPointIndex = snapPointsY.firstIndex(of: point) else { continue }
            if abs(point - snapPointsY[snapPointIndex - 1]) < minimumSnapDistance {
                snapPointsY.remove(at: snapPointIndex)
            }
        }
        SnapToPoint(animation: Animation.linear)
        snapPointsX = [0, -dimensions.width + minimumShortCardSize]
    }
    
    /// Toggle for forcing the card to be at max height and reverting to original height
    public func ToggleMaxOffset(isFull: Bool) {
        self.isFull = isFull
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 1, blendDuration: 0.2)) {
            if isFull {
                offsetCache = offset.height         // Save current height for eventually returning to it
                guard let maxSnapPoint = snapPointsY.max() else { return }
                offset.height = maxSnapPoint    // Snap to max height
                SetOpacities()
            }
            else {
                offset.height = offsetCache
                SetOpacities()
            }
        }
    }
    
    /// A one-stop-shop function for determining the background and foreground opacities
    private func SetOpacities() {
        SetBackgroundOpacity()
        SetForegroundOpacity()
    }
    
    /// Sets the background opacity for when the card is approaching, or is at its max height.
    /// The opacity's only changed when isShortCard is not enabled.
    private func SetBackgroundOpacity() {
        let fadeAtPercent: CGFloat = 0.75
        guard let maxValue = snapPointsY.max() else { return }
        backgroundFadePercent = isShortCard ? 0.0 : (offset.height - maxValue * fadeAtPercent) / (maxValue * (1 - fadeAtPercent))
    }
    
    /// Determines the foregroup opacity for when the drawer reaches the min height
    private func SetForegroundOpacity() {
        let finishAtPercent: CGFloat = 0.2
        guard let minValue = snapPointsY.min() else { return }
        foregroundFadePercent = ((offset.height / minValue) - 1) * (1 / finishAtPercent)
    }
    
    /// Used for calculating if the card should render as a "short card" or the full width of the screen.
    /// - Parameter width: current width of the screen
    public func IsShortCard(dimensions: CGSize) {
        recalculateSnapPoints(dimensions: dimensions)
        isShortCard = dimensions.width - minimumShortCardSize >= minimumMapSpace    // Calculate if the card is short or not
        SnapToPoint(animation: Animation.linear)
    }
    
    /// Control "stickiness" for card when dragging left or right
    /// - Parameters:
    ///   - value: Value from a drag gesture
    ///   - dampening: Dampening closure
    private func DragX(value: DragGesture.Value, dampening: (CGFloat, CGFloat) -> CGFloat) {
        guard let minGestureDistance = snapPointsX.map({ abs(value.location.x - minimumShortCardSize / 2 - $0) }).min(),
              let snapIndex = snapPointsX.firstIndex(where: { abs(value.location.x - minimumShortCardSize / 2 - $0) == minGestureDistance }),
              let minSnapPointX = snapPointsX.min(),
              let minDrawerDistance = snapPointsX.map({ abs(offset.width - $0) }).min(),
              let minDrawerDistanceIndex = snapPointsX.firstIndex(where: { abs(offset.width - $0) == minDrawerDistance }) else { return }
        
        if minDrawerDistanceIndex != snapIndex {                                                                                    // If the gesture desired snap point and drawer desired snap point are different, set the drawer's to the gesture's
            withAnimation(.easeInOut) {
                offset.width = snapPointsX[snapIndex]
            }
        }
        
        let distanceChangedX = value.translation.width - previousDrag.width                                                         // Distance dragged in the frame
        let distanceTrailing = abs(offset.width - snapPointsX[snapIndex])                                                           // Distance from the current snap point
        offset.width += offset.width != snapPointsX[snapIndex] ? dampening(distanceChangedX, distanceTrailing) : distanceChangedX   // If not currently sitting on a snap point then dampen.
        // Otherwise set exactly. This allows the initial dragging behavior
        if let maxSnapPointX = snapPointsX.max() {                                                                                  // Prevent drawer from going beyond the left bounds
            offset.width = min(maxSnapPointX, max(minSnapPointX, offset.width))
        }
    }
    
    /// Control snapping for card when dragging up and down
    /// - Parameters:
    ///   - value: Value from a drag gesture
    ///   - dampening: Dampening closure
    private func DragY(value: DragGesture.Value, dampening: (CGFloat, CGFloat) -> CGFloat) {
        let distanceChangedY = value.translation.height - previousDrag.height                               // Height distance changed between this and last frame
        guard let maxSnapPointY = snapPointsY.max(),
              let minSnapPointY = snapPointsY.min() else { return }
        
        SetOpacities()
        if offset.height > maxSnapPointY {                                                                  // If above bounds
            let distanceAbove = offset.height - maxSnapPointY                                               // Calculate how far above bounds
            offset.height -= dampening(distanceChangedY, distanceAbove)                                     // Slow down drag beyond bounds
        }
        else if offset.height < minSnapPointY {                                                             // If below bounds
            let distanceBelow = minSnapPointY - offset.height                                               // Calculate how far below bounds
            offset.height -= dampening(distanceChangedY, distanceBelow)                                     // Slow down drag beyond bounds
        }
        else {
            offset.height -= value.translation.height - previousDrag.height                                 // Inverted to allow for smaller values to be at bottom
        }
    }
    
    /// Calculates the position of the card when dragging. When the user goes too far above or below the maximum or minimum snap point, the card becomes "sticky".
    /// - Parameter value: The value calculated by a DragGesture.
    public func Drag(value: DragGesture.Value) {
        let dampening = { (dragAmount: CGFloat, distancePast: CGFloat) -> CGFloat in                        // Handle dampening when user drags drawer out of bounds
            return dragAmount * pow((distancePast / 10 + 1), -3 / 2)
        }
        DragY(value: value, dampening: dampening)
        if isShortCard {
            DragX(value: value, dampening: dampening)
        }
        
        previousDrag = value.translation                                                                    // Save current drag distance to allow for relative positioning on the line above
    }
    
    /// Determines which snap point the card should snap to when the user finishes dragging
    /// - Parameter value: The value calculated by a DragGesture
    public func SnapToPoint(animation: Animation = Animation.interactiveSpring(response: 0.2, dampingFraction: 1, blendDuration: 0.2)) {
        withAnimation(animation) {
            // y component
            if isFull {                                                              // Check if the card is supposed to be at max height
                guard let maxSnapPoint = snapPointsY.max() else { return }
                offset.height = maxSnapPoint                                                // Set the offset.height
            }
            else {                                                                          // If able to be at any snap point, calculate where it should be
                let distances = snapPointsY.map { abs(offset.height - $0) }                 // Figure out how far away sheet is from provided heights
                guard let minDistance = distances.min() else { return }
                guard let snapIndex = distances.firstIndex(of: minDistance) else { return } // Get the index of the snap point with smallest value
                offset.height = snapPointsY[snapIndex]                                      // Set the offset.height
            }
            SetOpacities()
            
            // x component
            if isFull {
                offset.width = 0
            }
            else {
                let distances = snapPointsX.map { abs(offset.width - $0) }                  // Figure out how far away sheet is from provided heights
                guard let minDistance = distances.min() else { return }
                guard let snapIndex = distances.firstIndex(of: minDistance) else { return } // Get the index of the snap point with smallest value
                offset.width = snapPointsX[snapIndex]                                       // Set the offset.width
            }
            
        }
        previousDrag = CGSize(width: 0, height: 0)                                          // Reset dragging
    }
    
    /// To implement tap to snap from bottom to middle, middle to top and top to bottom
    /// - Parameter animation: snap animations
    public func TapSnapToPoint(animation: Animation = Animation.interactiveSpring(response: 0.2, dampingFraction: 1, blendDuration: 0.2)) {
        print("Drawer Tapped")
    }
}
