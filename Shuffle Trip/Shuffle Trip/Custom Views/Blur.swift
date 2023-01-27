// Jan 22, 2023
// Ben Roberts

import SwiftUI

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    var opacity: CGFloat
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.backgroundColor = .systemBackground.withAlphaComponent(opacity)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        uiView.backgroundColor = .systemBackground.withAlphaComponent(opacity)
    }
}
