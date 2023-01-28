// Jan 27, 2023
// Ben Roberts

import SwiftUI

class BottomDrawerVM<Content: View>: ObservableObject {
    @Binding var goFull: Bool
    
    private let snapPointsValue: [CGFloat]
    public var snapPoints: [CGFloat] {  // Ensure snapPoints cannot be written to
        return snapPointsValue
    }
    
    init(goFull: Binding<Bool>, snapPoints: [CGFloat]) {
        self._goFull = goFull
        self.snapPointsValue = snapPoints.isEmpty ? [500] : snapPoints  // Ensure there's always some value in snapPoints
    }
}
