import SwiftUI

struct CategoryWrapper: Identifiable {
    let id = UUID()
    let name: String
}

public struct HomeFeedView: View {
    @Namespace private var animation
    @State private var selectedItem: ServiceItem?
    @State private var selectedCategory: CategoryWrapper?
    
    // Derived Data
    private var featuredItem: ServiceItem? { MockData.services.first(where: { $0.isFeatured }) }
    private var forYouItems: [ServiceItem] { Array(MockData.services.shuffled().prefix(6)) }
    private var trendingNewYork: [ServiceItem] {
        Array(MockData.services.filter { $0.location.contains("New York") }.prefix(3))
    }
    private var categories: [String] { Array(Set(MockData.services.map { $0.category })).sorted() }
    
    public init() {}
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 40) {
                // Floating Mesh Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome to Orbit")
                            .font(Font.antigravityBody())
                            .foregroundColor(Theme.Colors.secondaryText)
                        Text("Locanto Services")
                            .font(Font.antigravityHeading())
                            .foregroundColor(Theme.Colors.primaryText)
                            .neonGlow(color: Theme.Colors.electricBlue, radius: 10, opacity: 0.5)
                    }
                    Spacer()
                    Image(systemName: "bell.badge.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Theme.Colors.magentaPink)
                        .float(offset: 4, duration: 2.5)
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                // Hero Banner (Featured)
                if let featured = featuredItem {
                    HeroBanner(item: featured)
                        .onTapGesture { selectedItem = featured }
                        .padding(.horizontal, 24)
                }
                
                // Categories Grid (2 rows horizontal scroll)
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Explore the Galaxy")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: [GridItem(.fixed(50)), GridItem(.fixed(50))], spacing: 16) {
                            ForEach(categories, id: \.self) { category in
                                Button {
#if os(iOS)
                                    let impact = UIImpactFeedbackGenerator(style: .light)
                                    impact.impactOccurred()
#endif
                                    selectedCategory = CategoryWrapper(name: category)
                                } label: {
                                    Text(category)
                                        .font(Font.antigravityBody().weight(.semibold))
                                        .padding(.horizontal, 20)
                                        .frame(height: 50)
                                        .background(Theme.Colors.surfaceGlass)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .stroke(Theme.Colors.borderGlow, lineWidth: 0.5)
                                        )
                                        .foregroundColor(Theme.Colors.primaryText)
                                }
                                .buttonStyle(.plain)
                                .float(offset: CGFloat.random(in: 2...4), duration: Double.random(in: 3...5))
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                
                // For You (Horizontal List)
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Picked For You")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(forYouItems, id: \.id) { item in
                                ServiceCard(item: item, style: .compact)
                                    .frame(width: 280)
                                    .onTapGesture { selectedItem = item }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                    }
                }
                
                // Trending in New York (Vertical List)
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "Trending in New York")
                    
                    LazyVStack(spacing: 24) {
                        ForEach(trendingNewYork, id: \.id) { item in
                            ServiceCard(item: item, style: .full)
                                .onTapGesture { selectedItem = item }
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.9)
                                        .offset(y: phase.isIdentity ? 0 : 50)
                                }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer().frame(height: 120) // Space for floating tab bar
            }
        }
        .background(CosmicBackground())
        .ignoresSafeArea()
#if os(macOS)
        .sheet(item: $selectedItem) { item in
            ListingDetailView(item: item)
        }
        .sheet(item: $selectedCategory) { categoryWrapper in
            CategoryDetailView(categoryName: categoryWrapper.name)
        }
#else
        .fullScreenCover(item: $selectedItem) { item in
            ListingDetailView(item: item)
        }
        .fullScreenCover(item: $selectedCategory) { categoryWrapper in
            CategoryDetailView(categoryName: categoryWrapper.name)
        }
#endif
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(Font.antigravityHeading().weight(.bold))
            .foregroundColor(Theme.Colors.primaryText)
            .padding(.horizontal, 24)
    }
}

struct HeroBanner: View {
    let item: ServiceItem
    
    var body: some View {
        CosmicCard {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.Colors.neonGradient)
                    .frame(height: 220)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Theme.Colors.borderGlow, lineWidth: 0.5)
                    )
                
                Image(systemName: item.images.first ?? "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color.white)
                    .opacity(0.3)
                    .offset(x: 150, y: -20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("FEATURED")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                    
                    Text(item.title)
                        .font(Font.antigravityHeading().weight(.bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    Text(item.price)
                        .font(Font.antigravityBody().weight(.bold))
                        .foregroundColor(.white)
                }
                .padding(20)
            }
        }
    }
}

enum CardStyle {
    case compact, full
}

struct ServiceCard: View {
    let item: ServiceItem
    let style: CardStyle
    @State private var isLiked = false
    
    var body: some View {
        CosmicCard {
            VStack(alignment: .leading, spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(LinearGradient(colors: [Theme.Colors.background2, Theme.Colors.background1], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(height: style == .full ? 200 : 140)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Theme.Colors.borderGlow, lineWidth: 0.5)
                        )
                    
                    Image(systemName: item.images.first ?? "sparkles")
                        .font(.system(size: style == .full ? 60 : 40))
                        .foregroundColor(Theme.Colors.electricBlue)
                        .neonGlow(color: Theme.Colors.electricBlue)
                        .float(offset: 8, duration: 4.0)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(item.price)
                                .font(Font.antigravityBody().weight(.bold))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .padding(12)
                        }
                    }
                }
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(style == .full ? Font.antigravityHeading().weight(.bold) : Font.antigravityBody().weight(.bold))
                            .foregroundColor(Theme.Colors.primaryText)
                            .lineLimit(1)
                        
                        Text(item.location)
                            .font(Font.antigravityBody())
                            .foregroundColor(Theme.Colors.secondaryText)
                        
                        HStack(spacing: 12) {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Theme.Colors.electricBlue)
                                Text(String(format: "%.1f", item.rating))
                            }
                            Text("(\(item.reviewCount))")
                                .foregroundColor(Theme.Colors.secondaryText)
                        }
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.Colors.primaryText)
                        .padding(.top, 4)
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(Theme.Animation.antigravity) {
                            isLiked.toggle()
                        }
#if os(iOS)
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
#endif
                    } label: {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(isLiked ? Theme.Colors.magentaPink : Theme.Colors.secondaryText)
                            .scaleEffect(isLiked ? 1.2 : 1.0)
                            .neonGlow(color: isLiked ? Theme.Colors.magentaPink : .clear, radius: 10)
                    }
                    .buttonStyle(.plain)
                    .float(offset: 3, duration: 2.0)
                }
            }
        }
    }
}
