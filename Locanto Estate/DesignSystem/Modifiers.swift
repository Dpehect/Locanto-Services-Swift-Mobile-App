import SwiftUI

struct FloatingModifier: ViewModifier {
    @State private var isFloating = false
    var offset: CGFloat = 8
    var duration: Double = 4.0

    func body(content: Content) -> some View {
        content
            .offset(y: isFloating ? -offset : offset)
            .animation(
                Animation.easeInOut(duration: duration).repeatForever(autoreverses: true),
                value: isFloating
            )
            .onAppear {
                isFloating = true
            }
    }
}

struct NeonGlowModifier: ViewModifier {
    var color: Color
    var radius: CGFloat = 10
    var opacity: Double = 0.5

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(opacity), radius: radius, x: 0, y: 0)
    }
}

extension View {
    public func float(offset: CGFloat = 8, duration: Double = 4.0) -> some View {
        self.modifier(FloatingModifier(offset: offset, duration: duration))
    }
    
    public func neonGlow(color: Color, radius: CGFloat = 10, opacity: Double = 0.5) -> some View {
        self.modifier(NeonGlowModifier(color: color, radius: radius, opacity: opacity))
    }
    
    public func cosmicGlassmorphism(cornerRadius: CGFloat = 24) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Theme.Colors.borderGlow, lineWidth: 0.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
