import SwiftUI

public struct CategoryDetailView: View {
    let categoryName: String
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: ServiceItem?
    
    // We filter services by category
    private var categoryServices: [ServiceItem] {
        MockData.services.filter { $0.category == categoryName }
    }
    
    public init(categoryName: String) {
        self.categoryName = categoryName
    }
    
    public var body: some View {
        ZStack {
            Theme.Colors.background1.ignoresSafeArea()
            CosmicBackground().opacity(0.5)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Theme.Colors.primaryText)
                            .padding(16)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                            .neonGlow(color: Theme.Colors.primaryText, radius: 5, opacity: 0.2)
                    }
                    
                    Spacer()
                    
                    Text(categoryName.uppercased())
                        .font(Font.antigravityHeading().weight(.bold))
                        .foregroundColor(Theme.Colors.primaryText)
                        .tracking(4)
                        .neonGlow(color: Theme.Colors.electricBlue, radius: 10, opacity: 0.3)
                    
                    Spacer()
                    
                    // Invisible view for symmetry
                    Circle().frame(width: 52, height: 52).opacity(0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                .padding(.bottom, 20)
                
                // Result Count
                HStack {
                    Text("Found \(categoryServices.count) experiences in the galaxy")
                        .font(Font.antigravityBody())
                        .foregroundColor(Theme.Colors.secondaryText)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        ForEach(categoryServices, id: \.id) { item in
                            ServiceCard(item: item, style: .full)
                                .onTapGesture {
                                    selectedItem = item
                                }
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0.5)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                        .offset(y: phase.isIdentity ? 0 : 50)
                                }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 120)
                }
            }
        }
        .ignoresSafeArea()
#if os(macOS)
        .sheet(item: $selectedItem) { item in
            ListingDetailView(item: item)
        }
#else
        .fullScreenCover(item: $selectedItem) { item in
            ListingDetailView(item: item)
        }
#endif
    }
}
