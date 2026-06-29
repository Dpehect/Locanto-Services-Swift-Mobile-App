import SwiftUI

public struct LaunchScreenView: View {
    @State private var isAnimating = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            CosmicBackground()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Theme.Colors.neonGradient)
                        .frame(width: 120, height: 120)
                        .blur(radius: isAnimating ? 30 : 10)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.8 : 0.4)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                }
                .rotation3DEffect(.degrees(isAnimating ? 10 : -10), axis: (x: 1, y: 1, z: 0))
                
                Text("LOCANTO SERVICES")
                    .font(Font.antigravityDisplay())
                    .foregroundColor(Theme.Colors.primaryText)
                    .tracking(8)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                
                Text("Loading orbital data...")
                    .font(Font.antigravityBody())
                    .foregroundColor(Theme.Colors.secondaryText)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 10)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}
