// Jan 27, 2023
// Ben Roberts

import SwiftUI

@MainActor class BottomDrawerVM<Content: DrawerView>: ObservableObject {
    @Published var isShortCard: Bool = false
    
    private let defaultCardSize: CGFloat = 500
    @Published var snapPointsX: [CGFloat] { didSet {
        if snapPointsX.isEmpty {
            snapPointsX = [defaultCardSize]
        }
    }}
    private let rawSnapPointsY: [CGFloat]
    @Published var snapPointsY: [CGFloat] { didSet {
        if snapPointsY.isEmpty {
            snapPointsY = [defaultCardSize]
        }
    }}
    
    @Published var offset: CGSize
    private var offsetCache: CGFloat = 0
    private var previousDrag: CGSize = CGSize(width: 0, height: 0)
    @Published var fadePercent: Double = 0.0
    private var isFull: Bool = false
    
    @Published var content: Content
    
    public let minimumShortCardSize: CGFloat = 275
    public let minimumMapSpace: CGFloat = 200
    
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
                SetBackgroundOpacity()
            }
            else {
                offset.height = offsetCache
                SetBackgroundOpacity()
            }
        }
    }
    
    /// Sets the background opacity for when the card is approaching, or is at its max height.
    /// The opacity's only changed when isShortCard is not enabled.
    private func SetBackgroundOpacity() {
        let fadeAtPercent: CGFloat = 0.75
        guard let maxValue = snapPointsY.max() else { return }
        fadePercent = isShortCard ? 0.0 : (offset.height - maxValue * fadeAtPercent) / (maxValue * (1 - fadeAtPercent))
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
        
        SetBackgroundOpacity()
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
            SetBackgroundOpacity()
            
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
}
