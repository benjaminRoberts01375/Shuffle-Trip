// Jan 27, 2023
// Ben Roberts

import SwiftUI

@MainActor class BottomDrawerVM<Content: View>: ObservableObject {
    @ObservedObject var goFull: SearchTracker
    @Published var isShortCard: Bool = false
    
    @Published var snapPointsX: [CGFloat] { didSet {
        if snapPointsX.isEmpty {
            snapPointsX = [500]
        }
    }}
    private let rawSnapPointsY: [CGFloat]
    @Published var snapPointsY: [CGFloat] { didSet {
        if snapPointsY.isEmpty {
            snapPointsY = [500]
        }
    }}
    
    @Published var offset: CGSize
    private var offsetCache: CGFloat = 0
    private var previousDrag: CGSize = CGSize(width: 0, height: 0)
    @Published var fadePercent: Double = 0.0
    
    @Published var content: Content
    
    public let minimumShortCardSize: CGFloat = 275
    public let minimumMapSpace: CGFloat = 200
    
    init(content: Content, snapPoints: [CGFloat], goFull: SearchTracker) {
        let ensuredSnapPoints = snapPoints.isEmpty ? [500] : snapPoints
        self.snapPointsY = snapPoints.isEmpty ? [500] : snapPoints
        self.rawSnapPointsY = snapPoints
        self.snapPointsX = [0]
        self.offset = CGSize(width: 0, height: ensuredSnapPoints[0])
        self.goFull = goFull
        self.content = content
        self.goFull.AddUserSearchingAction {
            self.ToggleMaxOffset()
        }
    }
    
    /// Recalculates the snap points based on height of the screen, and snaps the drawer.
    /// - Parameter dimensions: Dimensions of the screen, usually from a `GeometryReader.size`
    private func recalculateSnapPoints(dimensions: CGSize) {
        snapPointsY = rawSnapPointsY.map{$0 < 1 ? dimensions.height * $0 : $0}
        SnapToPoint(animation: Animation.linear)
        snapPointsX = [0, -dimensions.width + minimumShortCardSize]
    }
    
    /// Toggle for forcing the card to be at max height and reverting to original height
    private func ToggleMaxOffset() {
        if goFull.isFull {
            offsetCache = offset.height
            withAnimation(.linear(duration: 0.2)) {
                offset.height = snapPointsY.max()!
                SetBackgroundOpacity()
            }
            return
        }
        withAnimation (.interactiveSpring(response: 0.35, dampingFraction: 0.75)) {
            offset.height = offsetCache
            SetBackgroundOpacity()
        }
    }
    
    /// Sets the background opacity for when the card is approaching, or is at its max height.
    /// The opacity's only changed when isShortCard is not enabled.
    private func SetBackgroundOpacity() {
        let fadeAtPercent: CGFloat = 0.75
        let maxValue = snapPointsY.max()!
        fadePercent = isShortCard ? 0.0 : (offset.height - maxValue * fadeAtPercent) / (maxValue * (1 - fadeAtPercent))
    }
    
    /// Used for calculating if the card should render as a "short card" or the full width of the screen.
    /// - Parameter width: current width of the screen
    public func IsShortCard(dimensions: CGSize) {
        recalculateSnapPoints(dimensions: dimensions)
        isShortCard = dimensions.width - minimumShortCardSize >= minimumMapSpace    // Calculate if the card is short or not
        SnapToPoint(animation: Animation.linear)
    }
    
    /// Calculates the position of the card when dragging. When the user goes too far above or below the maximum or minimum snap point, the card becomes "sticky".
    /// - Parameter value: The value calculated by a DragGesture.
    public func Drag(value: DragGesture.Value) {
        let dampening = { (dragAmount: CGFloat, distancePast: CGFloat) -> CGFloat in                // Handle dampening when user drags drawer out of bounds
            return dragAmount * pow((distancePast/10 + 1), -3/2)
        }
        
        // Y component
        let distanceChangedY = value.translation.height - previousDrag.height                       // Height distance changed between this and last frame
        SetBackgroundOpacity()
        if offset.height > snapPointsY.max()! {                                                     // If above bounds
            let distanceAbove = offset.height - snapPointsY.max()!                                  // Calculate how far above bounds
            offset.height -= dampening(distanceChangedY, distanceAbove)                             // Slow down drag beyond bounds
        }
        else if offset.height < snapPointsY.min()! {                                                // If below bounds
            let distanceBelow = snapPointsY.min()! - offset.height                                  // Calculate how far below bounds
            offset.height -= dampening(distanceChangedY, distanceBelow)                             // Slow down drag beyond bounds
        }
        else {
            offset.height -= value.translation.height - previousDrag.height                         // Inverted to allow for smaller values to be at bottom
        }
        
        if isShortCard {                                                                            // X component only with short card
            let cDistances = snapPointsX.map{abs(offset.width - $0)}
            let gDistances = snapPointsX.map{abs(value.location.x - minimumShortCardSize/2 - $0)}   // Figure out how far away sheet is from provided heights
            let snapIndex = gDistances.firstIndex(of: gDistances.min()!)!                           // Get the index of the snap point with smallest value
            let distanceChangedX = value.translation.width - previousDrag.width                     // Width distance changed between this and last frame
            
            if cDistances.firstIndex(of: cDistances.min()!)! != snapIndex {                         // If the snap point of the gesture differs from where the card currently wants to snap to, the card needs to change sides of the screen
                withAnimation(.easeInOut) {
                    offset.width = snapPointsX[snapIndex]                                           // Snap to the correct side of the screen. Needs to be done without `SnapToPoint()` since it's based on the finger's position, not offset
                }
            }
            
            if offset.width > snapPointsX[snapIndex] || offset.width < snapPointsX[snapIndex] {     // Dampen when being brought away from a snap point
                let distanceTrailing = abs(offset.width - snapPointsX[snapIndex])
                offset.width += dampening(distanceChangedX, distanceTrailing)
            }
            else {                                                                                  // Exists to allow user to drag card out of specific snap zones
                offset.width += distanceChangedX                                                    // The "first step" in dragging the drawer
            }
            
            if offset.width > snapPointsX.max()! {                                                  // Prevent drawer from going beyond the right bounds
                offset.width = snapPointsX.max()!
            }
            else if offset.width < snapPointsX.min()! {                                             // Prevent drawer from going beyond the left bounds
                offset.width = snapPointsX.min()!
            }
        }
                    
        previousDrag = value.translation                                                            // Save current drag distance to allow for relative positioning on the line above
    }
    
    /// Determines which snap point the card should snap to when the user finishes dragging
    /// - Parameter value: The value calculated by a DragGesture
    public func SnapToPoint(animation: Animation = Animation.interactiveSpring(response: 0.2, dampingFraction: 1, blendDuration: 0.2)) {
        withAnimation (animation) {
            // y component
            if goFull.isFull {                                              // Check if the card is supposed to be at max height
                offset.height = snapPointsY.max()!                          // Set the offset.height
            }
            else {                                                          // If able to be at any snap point, calculate where it should be
                let distances = snapPointsY.map{abs(offset.height - $0)}    // Figure out how far away sheet is from provided heights
                let snapIndex = distances.firstIndex(of: distances.min()!)! // Get the index of the snap point with smallest value
                offset.height = snapPointsY[snapIndex]                      // Set the offset.height
            }
            SetBackgroundOpacity()
            
            // x component
            if goFull.isFull {
                offset.width = 0
            }
            else {
                let distances = snapPointsX.map{abs(offset.width - $0)}     // Figure out how far away sheet is from provided heights
                let snapIndex = distances.firstIndex(of: distances.min()!)! // Get the index of the snap point with smallest value
                offset.width = snapPointsX[snapIndex]                       // Set the offset.width
            }
            
        }
        previousDrag = CGSize(width: 0, height: 0)                          // Reset dragging
    }
}
