// Jan 22, 2023
// Ben Roberts

import SwiftUI

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    @Binding var opacity: Double
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.backgroundColor = .systemBackground.withAlphaComponent(CGFloat(opacity * 2))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        uiView.backgroundColor = .systemBackground.withAlphaComponent(CGFloat(opacity * 2))
    }
}
