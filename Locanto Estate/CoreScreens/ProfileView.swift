import SwiftUI

public struct ProfileView: View {
    @State private var showingEditAlert = false
    @State private var showingSettingsAlert = false
    
    public init() {}
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                // Top Bar
                HStack {
                    Spacer()
                    Button {
                        showingEditAlert = true
                    } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Theme.Colors.primaryText)
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Button {
                        showingSettingsAlert = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Theme.Colors.primaryText)
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                // Header Profile
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Theme.Colors.neonGradient)
                            .frame(width: 100, height: 100)
                            .neonGlow(color: Theme.Colors.magentaPink, radius: 15)
                            .float(offset: 6, duration: 3.5) // Kept for the main avatar
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color.white)
                    }
                    
                    VStack(spacing: 4) {
                        Text("Space Commander")
                            .font(Font.antigravityHeading().weight(.bold))
                            .foregroundColor(Theme.Colors.primaryText)
                        Text("Level 42 Explorer")
                            .font(Font.antigravityBody())
                            .foregroundColor(Theme.Colors.electricBlue)
                    }
                }
                
                // Stats
                HStack(spacing: 16) {
                    StatBubble(title: "Active Ads", value: "3")
                    StatBubble(title: "Favorites", value: "12")
                    StatBubble(title: "Reviews", value: "8")
                }
                .padding(.horizontal, 24)
                
                // My Ads
                VStack(alignment: .leading, spacing: 16) {
                    Text("My Services")
                        .font(Font.antigravityHeading().weight(.bold))
                        .foregroundColor(Theme.Colors.primaryText)
                        .padding(.horizontal, 24)
                    
                    LazyVStack(spacing: 24) {
                        ForEach(MockData.services.prefix(2), id: \.id) { item in
                            ServiceCard(item: item, style: .compact)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer().frame(height: 120)
            }
        }
        .background(CosmicBackground())
        .alert("Edit Hologram 👤", isPresented: $showingEditAlert) {
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Profile editing module is currently syncing with the mainframe.")
        }
        .alert("System Settings ⚙️", isPresented: $showingSettingsAlert) {
            Button("Dismiss", role: .cancel) { }
        } message: {
            Text("Control panel access is restricted in this quadrant.")
        }
        .ignoresSafeArea()
    }
}

struct StatBubble: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
                .neonGlow(color: Theme.Colors.primaryText, radius: 5, opacity: 0.5)
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .cosmicGlassmorphism(cornerRadius: 24)
    }
}
