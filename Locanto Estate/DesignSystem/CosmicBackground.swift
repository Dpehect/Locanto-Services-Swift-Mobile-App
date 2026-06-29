import SwiftUI

public struct CosmicBackground: View {
    @State private var phase: Float = 0.0
    
    public init() {}
    
    public var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0, 0.5),
                .init(0.5 + 0.1 * sin(phase), 0.5 + 0.1 * cos(phase)),
                .init(1, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1)
            ],
            colors: [
                Theme.Colors.background1, Theme.Colors.background2, Theme.Colors.background1,
                Theme.Colors.cosmicViolet.opacity(0.3), Theme.Colors.electricBlue.opacity(0.2), Theme.Colors.background2,
                Theme.Colors.background1, Theme.Colors.magentaPink.opacity(0.15), Theme.Colors.background1
            ]
        )
        .ignoresSafeArea()
        .background(Theme.Colors.background1)
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}
