import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct LevitatingButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isPrimary: Bool
    
    @State private var isHovered = false
    
    public init(title: String, icon: String? = nil, isPrimary: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isPrimary = isPrimary
        self.action = action
    }
    
    public var body: some View {
        Button {
            withAnimation(Theme.Animation.antigravity) {
                isHovered = true
            }
#if os(iOS)
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
#endif
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(Theme.Animation.antigravity) {
                    isHovered = false
                }
                action()
            }
        } label: {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                }
                Text(title)
                    .font(Font.antigravityBody().weight(.semibold))
            }
            .foregroundColor(.white)
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .background(
                Group {
                    if isPrimary {
                        Theme.Colors.neonGradient
                    } else {
                        Color.clear
                    }
                }
            )
            .cosmicGlassmorphism(cornerRadius: 30)
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .offset(y: isHovered ? -4 : 0)
            .neonGlow(color: isPrimary ? Theme.Colors.electricBlue : .clear, radius: isHovered ? 20 : 10, opacity: isHovered ? 0.8 : 0.4)
        }
        .buttonStyle(.plain)
    }
}
