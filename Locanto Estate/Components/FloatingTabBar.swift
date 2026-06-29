import SwiftUI

public enum TabItem: String, CaseIterable {
    case home = "sparkles.rectangle.stack.fill"
    case search = "magnifyingglass"
    case post = "plus.circle.fill"
    case profile = "person.crop.circle"
}

public struct FloatingTabBar: View {
    @Binding var selectedTab: TabItem
    @Namespace private var animation
    
    public init(selectedTab: Binding<TabItem>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button {
                    withAnimation(Theme.Animation.antigravity) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == tab ? Theme.Colors.electricBlue : Theme.Colors.secondaryText)
                            .neonGlow(color: selectedTab == tab ? Theme.Colors.electricBlue : .clear, radius: 10)
                            .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                            .offset(y: selectedTab == tab ? -8 : 0)
                        
                        if selectedTab == tab {
                            Circle()
                                .fill(Theme.Colors.electricBlue)
                                .frame(width: 4, height: 4)
                                .matchedGeometryEffect(id: "tabIndicator", in: animation)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(
            Capsule()
                .fill(Theme.Colors.surfaceGlass)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(
                    Capsule()
                        .stroke(Theme.Colors.borderGlow, lineWidth: 1)
                )
        )
        .padding(.horizontal, 32)
        .padding(.bottom, 24)
        .float(offset: 4, duration: 4.0)
    }
}
