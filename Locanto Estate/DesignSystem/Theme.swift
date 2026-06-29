import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension Color {
    init(light: Color, dark: Color) {
#if canImport(UIKit)
        self.init(uiColor: UIColor(dynamicProvider: { traits in
            switch traits.userInterfaceStyle {
            case .light, .unspecified: return UIColor(light)
            case .dark: return UIColor(dark)
            @unknown default: return UIColor(light)
            }
        }))
#elseif canImport(AppKit)
        self.init(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
            if appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua {
                return NSColor(dark)
            } else {
                return NSColor(light)
            }
        }))
#else
        self = dark
#endif
    }
}

public enum Theme {
    public enum Colors {
        // Deep Space (Dark) vs Holographic Soft (Light)
        public static let background1 = Color(
            light: Color(red: 0.95, green: 0.96, blue: 0.98),
            dark: Color(red: 0.02, green: 0.02, blue: 0.04)
        )
        
        public static let background2 = Color(
            light: Color(red: 0.98, green: 0.99, blue: 1.0),
            dark: Color(red: 0.04, green: 0.05, blue: 0.08)
        )
        
        public static let primaryText = Color(
            light: Color(red: 0.1, green: 0.1, blue: 0.15),
            dark: .white
        )
        
        public static let secondaryText = Color(
            light: Color(red: 0.4, green: 0.4, blue: 0.5),
            dark: Color.white.opacity(0.6)
        )
        
        // Accents
        public static let electricBlue = Color(
            light: Color(red: 0.0, green: 0.6, blue: 0.8),
            dark: Color(red: 0.0, green: 0.94, blue: 1.0)
        )
        
        public static let cosmicViolet = Color(
            light: Color(red: 0.4, green: 0.2, blue: 0.8),
            dark: Color(red: 0.54, green: 0.17, blue: 0.89)
        )
        
        public static let magentaPink = Color(
            light: Color(red: 0.9, green: 0.1, blue: 0.4),
            dark: Color(red: 1.0, green: 0.0, blue: 0.5)
        )
        
        // Surfaces
        public static let surfaceGlass = Color(
            light: Color.black.opacity(0.04),
            dark: Color.white.opacity(0.05)
        )
        
        public static let borderGlow = Color(
            light: Color.black.opacity(0.1),
            dark: Color.white.opacity(0.15)
        )
        
        // Gradients
        public static let neonGradient = LinearGradient(
            colors: [electricBlue, cosmicViolet, magentaPink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    public enum Animation {
        // A soft, low-gravity spring feeling
        public static let antigravity = SwiftUI.Animation.spring(
            response: 0.7,
            dampingFraction: 0.65,
            blendDuration: 0.2
        )
        
        public static let float = SwiftUI.Animation.easeInOut(duration: 4.0).repeatForever(autoreverses: true)
    }
}

// Typography extension
extension Font {
    public static func antigravityDisplay() -> Font {
        .system(size: 42, weight: .bold, design: .rounded)
    }
    
    public static func antigravityHeading() -> Font {
        .system(size: 28, weight: .semibold, design: .rounded)
    }
    
    public static func antigravityBody() -> Font {
        .system(size: 16, weight: .regular, design: .rounded)
    }
}
