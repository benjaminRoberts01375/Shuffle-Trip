// Jan 27, 2023
// Ben Roberts

import SwiftUI

@MainActor class BottomDrawerVM<Content: View>: ObservableObject {
    @ObservedObject var goFull: SearchTracker
    @Published var isShortCard: Bool = false
    
    private let rawSnapPoints: [CGFloat]
    @Published var snapPoints: [CGFloat] { didSet {
        if snapPoints.isEmpty {
            snapPoints = [500]
        }
    }}
    
    @Published var offset: CGFloat
    private var offsetCache: CGFloat = 0
    private var previousDrag: CGFloat = 0
    @Published var fadePercent: Double = 0.0
    
    @Published var content: Content
    
    public let minimumShortCardSize: CGFloat = 275
    public let minimumMapSpace: CGFloat = 200
    
    init(content: Content, snapPoints: [CGFloat], goFull: SearchTracker) {
        let ensuredSnapPoints = snapPoints.isEmpty ? [500] : snapPoints
        self.snapPoints = snapPoints.isEmpty ? [500] : snapPoints
        self.rawSnapPoints = snapPoints
        self.offset = ensuredSnapPoints[0]
        self.goFull = goFull
        self.content = content
        self.goFull.AddUserSearchingAction {
            self.ToggleMaxOffset()
        }
    }
    
    /// Recalculates the snap points based on height of the screen, and snaps the drawer.
    /// - Parameter dimensions: Dimensions of the screen, usually from a `GeometryReader.size`
    private func recalculateSnapPoints(dimensions: CGSize) {
        snapPoints = rawSnapPoints.map{$0 < 1 ? dimensions.height * $0 : $0}
        SnapToPoint()
    }
    
    /// Toggle for forcing the card to be at max height and reverting to original height
    private func ToggleMaxOffset() {
        if goFull.isFull {
            offsetCache = offset
            withAnimation(.linear(duration: 0.2)) {
                offset = snapPoints.max()!
                SetBackgroundOpacity()
            }
            return
        }
        withAnimation (.interactiveSpring(response: 0.35, dampingFraction: 0.75)) {
            offset = offsetCache
            SetBackgroundOpacity()
        }
    }
    
    /// Sets the background opacity for when the card is approaching, or is at its max height.
    /// The opacity's only changed when isShortCard is not enabled.
    private func SetBackgroundOpacity() {
        let fadeAtPercent: CGFloat = 0.75
        let maxValue = snapPoints.max()!
        fadePercent = isShortCard ? 0.0 : (offset - maxValue * fadeAtPercent) / (maxValue * (1 - fadeAtPercent))
    }
    
    /// Used for calculating if the card should render as a "short card" or the full width of the screen.
    /// - Parameter width: current width of the screen
    public func IsShortCard(dimensions: CGSize) {
        recalculateSnapPoints(dimensions: dimensions)
        isShortCard = dimensions.width - minimumShortCardSize >= minimumMapSpace   // Calculate if the card is short or not
        SnapToPoint()
    }
    
    /// Calculates the position of the card when dragging. When the user goes too far above or below the maximum or minimum snap point, the card becomes "sticky".
    /// - Parameter value: The value calculated by a DragGesture.
    public func Drag(value: DragGesture.Value) {
        let distanceChanged = value.translation.height - previousDrag           // Distance changed between this and last frame
        withAnimation(.linear) {
            SetBackgroundOpacity()
            if offset > snapPoints.max()! {                                     // If above bounds
                let distanceAbove = offset - snapPoints.max()!                  // Calculate how far above bounds
                offset -= distanceChanged * pow((distanceAbove/10 + 1), -3/2)   // Slow down drag beyond bounds
            }
            else if offset < snapPoints.min()! {                                // If below bounds
                let distanceBelow = snapPoints.min()! - offset                  // Calculate how far below bounds
                offset -= distanceChanged * pow((distanceBelow/10) + 1, -3/2)   // Slow down drag beyond bounds
            }
            else {
                offset -= value.translation.height - previousDrag               // Inverted to allow for smaller values to be at bottom
            }
        }
        previousDrag = value.translation.height                                 // Save current drag distance to allow for relative positioning on the line above
    }
    
    /// Determines which snap point the card should snap to when the user finishes dragging
    /// - Parameter value: The value calculated by a DragGesture
    public func SnapToPoint() {
        withAnimation (.interactiveSpring(response: 0.2, dampingFraction: 1/2)) {
            let distances = snapPoints.map{abs(offset - $0)}                // Figure out how far away sheet is from provided heights
            if goFull.isFull {                                              // Check if the card is supposed to be at max height
                offset = snapPoints.max()!                                  // Set the offset
            }
            else {                                                          // If able to be at any snap point, calculate where it should be
                let snapIndex = distances.firstIndex(of: distances.min()!)! // Get the index of the snap point with smallest value
                offset = snapPoints[snapIndex]                              // Set the offset
            }
            SetBackgroundOpacity()
        }
        previousDrag = 0                                                    // Reset dragging
    }
}
