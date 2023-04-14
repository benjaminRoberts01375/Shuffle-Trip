// Jan 22, 2023
// Ben Roberts

import SwiftUI

/// A custom view for handling bluring and unbluring backgrounds
struct BlurView: UIViewRepresentable {
    // The type of blur effect
    let style: UIBlurEffect.Style
    /// Amount of blur shown. 1 = No blur, 2 = Max blur
    var opacity: CGFloat
    
    /// Initial blur appearance
    /// - Parameter context: Provided by system
    /// - Returns: The newly blured background
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.backgroundColor = .systemBackground.withAlphaComponent(opacity)
        return view
    }
    
    /// Adjusted blur appearance
    /// - Parameters:
    ///   - uiView: The blur being updated
    ///   - context: Provided by system
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        uiView.backgroundColor = .systemBackground.withAlphaComponent(opacity)
    }
}
