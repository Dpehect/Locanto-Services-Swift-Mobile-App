import SwiftUI

public struct SearchPage: View {
    @State private var searchText = ""
    @State private var selectedCategory: CategoryWrapper?
    @State private var selectedItem: ServiceItem?
    
    private let trendingSearches = ["Cleaning", "Repair", "Digital", "Design", "Tutor"]
    
    // Computed property for filtered results
    private var searchResults: [ServiceItem] {
        if searchText.isEmpty {
            return []
        } else {
            return MockData.services.filter { item in
                item.title.localizedCaseInsensitiveContains(searchText) ||
                item.category.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public init() {}
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                Text("Search the Universe")
                    .font(Font.antigravityHeading())
                    .foregroundColor(Theme.Colors.primaryText)
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Theme.Colors.secondaryText)
                    TextField("What are you looking for?", text: $searchText)
                        .font(Font.antigravityBody())
                        .foregroundColor(Theme.Colors.primaryText)
                        .disableAutocorrection(true)
                    
                    if !searchText.isEmpty {
                        Button {
                            withAnimation { searchText = "" }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Theme.Colors.secondaryText)
                        }
                    }
                }
                .padding()
                .background(Theme.Colors.surfaceGlass)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Theme.Colors.borderGlow, lineWidth: 0.5)
                )
                .padding(.horizontal, 24)
                
                if searchText.isEmpty {
                    // Default State: Trending & Categories
                    
                    // Trending Searches
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Trending Searches")
                            .font(Font.antigravityBody().weight(.bold))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(trendingSearches, id: \.self) { search in
                                    Button {
                                        withAnimation {
                                            searchText = search
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "flame.fill")
                                                .foregroundColor(Theme.Colors.magentaPink)
                                                .font(.system(size: 12))
                                            Text(search)
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .foregroundColor(Theme.Colors.primaryText)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Theme.Colors.surfaceGlass)
                                        .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    // Categories Grid
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Browse Categories")
                            .font(Font.antigravityBody().weight(.bold))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .padding(.horizontal, 24)
                        
                        let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
                        let categories = Array(Set(MockData.services.map { $0.category })).sorted()
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(categories, id: \.self) { category in
                                Button {
                                    selectedCategory = CategoryWrapper(name: category)
                                } label: {
                                    CategoryCard(category: category)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                } else {
                    // Active Search State: Show Results
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Found \(searchResults.count) results for '\(searchText)'")
                            .font(Font.antigravityBody().weight(.bold))
                            .foregroundColor(Theme.Colors.secondaryText)
                            .padding(.horizontal, 24)
                        
                        LazyVStack(spacing: 24) {
                            ForEach(searchResults, id: \.id) { item in
                                ServiceCard(item: item, style: .compact)
                                    .onTapGesture {
                                        selectedItem = item
                                    }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                
                Spacer().frame(height: 120)
            }
        }
        .background(CosmicBackground())
        .ignoresSafeArea()
#if os(macOS)
        .sheet(item: $selectedCategory) { categoryWrapper in
            CategoryDetailView(categoryName: categoryWrapper.name)
        }
        .sheet(item: $selectedItem) { item in
            ListingDetailView(item: item)
        }
#else
        .fullScreenCover(item: $selectedCategory) { categoryWrapper in
            CategoryDetailView(categoryName: categoryWrapper.name)
        }
        .fullScreenCover(item: $selectedItem) { item in
            ListingDetailView(item: item)
        }
#endif
    }
}

struct CategoryCard: View {
    let category: String
    
    var body: some View {
        CosmicCard {
            HStack {
                Text(category)
                    .font(Font.antigravityBody().weight(.semibold))
                    .foregroundColor(Theme.Colors.primaryText)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.Colors.electricBlue)
                    .font(.system(size: 14, weight: .bold))
            }
        }
    }
}
