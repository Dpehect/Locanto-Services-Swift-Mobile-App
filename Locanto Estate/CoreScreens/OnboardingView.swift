import SwiftUI

public struct OnboardingView: View {
    @State private var phase = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    public init() {}
    
    public var body: some View {
        ZStack {
            CosmicBackground()
            
            VStack {
                Spacer()
                
                VStack(spacing: 24) {
                    Image(systemName: "sparkles.rectangle.stack.fill")
                        .font(.system(size: 80, weight: .thin))
                        .foregroundColor(Theme.Colors.electricBlue)
                        .neonGlow(color: Theme.Colors.electricBlue, radius: 20)
                        .float(offset: 12, duration: 3.5)
                        .gyroTilt(intensity: 15.0)
                    
                    Text("Locanto Services")
                        .font(Font.antigravityDisplay())
                        .foregroundColor(Theme.Colors.primaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .neonGlow(color: Theme.Colors.primaryText, radius: 5, opacity: 0.3)
                    
                    Text("Discover weightless services and levitating experiences.")
                        .font(Font.antigravityBody())
                        .foregroundColor(Theme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .offset(y: phase == 0 ? 50 : 0)
                .opacity(phase == 0 ? 0 : 1)
                .animation(Theme.Animation.antigravity.delay(0.2), value: phase)
                
                Spacer()
                
                LevitatingButton(title: "Enter the Universe", icon: "arrow.right", isPrimary: true) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        hasSeenOnboarding = true
                    }
                }
                .opacity(phase == 0 ? 0 : 1)
                .animation(Theme.Animation.antigravity.delay(0.5), value: phase)
                .padding(.bottom, 64)
            }
        }
        .onAppear {
            phase = 1
        }
    }
}
