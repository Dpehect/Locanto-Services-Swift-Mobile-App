import SwiftUI

public struct ListingDetailView: View {
    let item: ServiceItem
    @Environment(\.dismiss) private var dismiss
    @State private var showingBookingSheet = false
    @State private var showingFavoriteAlert = false
    
    public init(item: ServiceItem) {
        self.item = item
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            GeometryReader { proxy in
                let minY = proxy.frame(in: .global).minY
                let isScrollingDown = minY < 0
                
                ZStack(alignment: .bottomLeading) {
                    // Gallery TabView
                    TabView {
                        ForEach(0..<max(1, item.images.count), id: \.self) { index in
                            let imageName = item.images.isEmpty ? "sparkles" : item.images[index]
                            
                            ZStack {
                                LinearGradient(colors: [Theme.Colors.background2, Theme.Colors.background1], startPoint: .topLeading, endPoint: .bottomTrailing)
                                
                                Image(systemName: imageName)
                                    .font(.system(size: 80))
                                    .foregroundColor(Theme.Colors.electricBlue)
                                    .neonGlow(color: Theme.Colors.electricBlue, radius: 20)
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: isScrollingDown ? -minY * 0.5 : -minY)
                    .scaleEffect(isScrollingDown ? 1.0 : 1.0 + minY / 500)
                    .blur(radius: isScrollingDown ? -minY / 20 : 0)
                    
                    // Floating Content Overlay
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(item.category.uppercased())
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.Colors.magentaPink)
                                .tracking(2)
                                .neonGlow(color: Theme.Colors.magentaPink, radius: 5)
                            
                            if item.isVerified {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(Theme.Colors.electricBlue)
                                    .neonGlow(color: Theme.Colors.electricBlue, radius: 5)
                            }
                        }
                        
                        Text(item.title)
                            .font(Font.antigravityDisplay())
                            .foregroundColor(Theme.Colors.primaryText)
                            .lineLimit(2)
                    }
                    .padding(24)
                    .offset(y: isScrollingDown ? -minY * 0.2 : 0)
                }
                .frame(height: 450 + (isScrollingDown ? 0 : minY))
                .offset(y: isScrollingDown ? minY : 0)
            }
            .frame(height: 450)
            
            VStack(alignment: .leading, spacing: 32) {
                // Info Cards
                HStack(spacing: 12) {
                    InfoBubble(title: "Starting from", value: item.price)
                    InfoBubble(title: "Rating", value: "★ \(String(format: "%.1f", item.rating))")
                    InfoBubble(title: "Reviews", value: "\(item.reviewCount)+")
                }
                .padding(.horizontal, 24)
                
                // Description
                VStack(alignment: .leading, spacing: 16) {
                    Text("About this Service")
                        .font(Font.antigravityHeading())
                        .foregroundColor(Theme.Colors.primaryText)
                    
                    Text(item.description)
                        .font(Font.antigravityBody())
                        .foregroundColor(Theme.Colors.secondaryText)
                        .lineSpacing(6)
                }
                .padding(.horizontal, 24)
                
                // Pricing Options
                if !item.pricingOptions.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Packages")
                            .font(Font.antigravityHeading())
                            .foregroundColor(Theme.Colors.primaryText)
                            .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(item.pricingOptions) { option in
                                    PricingCard(option: option)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
                
                // Reviews
                if !item.reviews.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Stellar Reviews")
                            .font(Font.antigravityHeading())
                            .foregroundColor(Theme.Colors.primaryText)
                            .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(item.reviews) { review in
                                    ReviewCard(review: review)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                }
                
                Spacer().frame(height: 100)
            }
            .background(CosmicBackground())
            .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
            .offset(y: -40)
        }
        .background(Theme.Colors.background1.ignoresSafeArea())
        .overlay(alignment: .top) {
            // Levitating Action Buttons (Back & Favorite)
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
                
                Button {
                    showingFavoriteAlert = true
#if os(iOS)
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
#endif
                } label: {
                    Image(systemName: "heart")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Theme.Colors.primaryText)
                        .padding(16)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .neonGlow(color: Theme.Colors.primaryText, radius: 5, opacity: 0.2)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 60)
            .float(offset: 2, duration: 3.0)
        }
        .overlay(alignment: .bottom) {
            LevitatingButton(title: "Book Now", icon: "sparkles", isPrimary: true) {
                showingBookingSheet = true
            }
            .padding(.bottom, 32)
        }
        .sheet(isPresented: $showingBookingSheet) {
            BookingWizardView(item: item)
        }
        .alert("Added to Favorites 💫", isPresented: $showingFavoriteAlert) {
            Button("Cool", role: .cancel) { }
        } message: {
            Text("'\(item.title)' is now saved to your favorite experiences.")
        }
        .ignoresSafeArea()
    }
}

struct PricingCard: View {
    let option: PricingOption
    
    var body: some View {
        CosmicCard {
            VStack(alignment: .leading, spacing: 12) {
                Text(option.title)
                    .font(Font.antigravityBody().weight(.bold))
                    .foregroundColor(Theme.Colors.magentaPink)
                
                Text(option.price)
                    .font(Font.antigravityDisplay())
                    .foregroundColor(Theme.Colors.primaryText)
                
                Text(option.description)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.Colors.secondaryText)
                    .lineLimit(3)
            }
            .frame(width: 200, alignment: .leading)
        }
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        CosmicCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(review.userName)
                        .font(Font.antigravityBody().weight(.bold))
                        .foregroundColor(Theme.Colors.primaryText)
                    Spacer()
                    Text(review.date)
                        .font(.system(size: 12))
                        .foregroundColor(Theme.Colors.secondaryText)
                }
                
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(review.rating) ? "star.fill" : "star")
                            .foregroundColor(Theme.Colors.electricBlue)
                            .font(.system(size: 12))
                    }
                }
                
                Text(review.comment)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.Colors.primaryText)
                    .lineLimit(4)
            }
            .frame(width: 250, alignment: .leading)
        }
    }
}

struct InfoBubble: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Theme.Colors.secondaryText)
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Theme.Colors.primaryText)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 4)
        .cosmicGlassmorphism(cornerRadius: 20)
    }
}
