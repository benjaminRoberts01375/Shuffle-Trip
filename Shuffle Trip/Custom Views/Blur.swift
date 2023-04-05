// Jan 22, 2023
// Ben Roberts

import SwiftUI

/// A custom view for handling bluring and unbluring backgrounds
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style   // The type of blur effect
    var opacity: CGFloat            // How much of the blur is shown
    
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
