import Foundation

public struct PricingOption: Identifiable {
    public let id = UUID()
    public var title: String
    public var price: String
    public var description: String
    
    public init(title: String, price: String, description: String) {
        self.title = title
        self.price = price
        self.description = description
    }
}

public struct Review: Identifiable {
    public let id = UUID()
    public var userName: String
    public var rating: Double
    public var comment: String
    public var date: String
    
    public init(userName: String, rating: Double, comment: String, date: String) {
        self.userName = userName
        self.rating = rating
        self.comment = comment
        self.date = date
    }
}

public struct ServiceItem: Identifiable, Hashable {
    public let id = UUID()
    public var title: String
    public var description: String
    public var price: String
    public var location: String
    public var category: String
    public var subcategory: String
    public var images: [String]
    public var rating: Double
    public var reviewCount: Int
    public var postedDate: Date
    public var isFeatured: Bool
    public var isVerified: Bool
    
    public var pricingOptions: [PricingOption]
    public var reviews: [Review]
    
    public init(
        title: String, description: String, price: String, location: String,
        category: String, subcategory: String, images: [String],
        rating: Double, reviewCount: Int, postedDate: Date = Date(),
        isFeatured: Bool = false, isVerified: Bool = true,
        pricingOptions: [PricingOption] = [], reviews: [Review] = []
    ) {
        self.title = title
        self.description = description
        self.price = price
        self.location = location
        self.category = category
        self.subcategory = subcategory
        self.images = images
        self.rating = rating
        self.reviewCount = reviewCount
        self.postedDate = postedDate
        self.isFeatured = isFeatured
        self.isVerified = isVerified
        self.pricingOptions = pricingOptions
        self.reviews = reviews
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func ==(lhs: ServiceItem, rhs: ServiceItem) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct MockData {
    public static let standardReviews = [
        Review(userName: "John D.", rating: 5.0, comment: "Excellent service, completed right on time and flawlessly.", date: "2 days ago"),
        Review(userName: "Sarah K.", rating: 4.5, comment: "Overall very satisfied. Thanks.", date: "1 week ago"),
        Review(userName: "Michael B.", rating: 5.0, comment: "Professional approach, I recommend to everyone.", date: "3 weeks ago")
    ]
    
    public static let premiumReviews = standardReviews + [
        Review(userName: "Emily W.", rating: 5.0, comment: "The best service I've ever received, worth every penny.", date: "1 month ago"),
        Review(userName: "David T.", rating: 4.8, comment: "Quality workmanship and great communication.", date: "2 months ago")
    ]

    private static let baseServices: [ServiceItem] = [
        // CLEANING
        ServiceItem(title: "Deep House Cleaning", description: "Comprehensive, anti-allergic deep cleaning service covering every corner of your home. All-day service with our 3-person professional team.", price: "$120", location: "New York, Manhattan", category: "Cleaning", subcategory: "House", images: ["sparkles", "bubbles.and.sparkles", "house.fill"], rating: 4.9, reviewCount: 124, isFeatured: true, pricingOptions: [
            PricingOption(title: "1 Bedroom", price: "$120", description: "Standard cleaning"),
            PricingOption(title: "3 Bedrooms", price: "$200", description: "Deep cleaning")
        ], reviews: premiumReviews),
        ServiceItem(title: "Office Cleaning (Monthly)", description: "Periodic office cleaning to keep your workspace fresh.", price: "$400/Mo", location: "California, Los Angeles", category: "Cleaning", subcategory: "Office", images: ["briefcase.fill", "sparkles"], rating: 4.7, reviewCount: 45),
        ServiceItem(title: "Sofa Washing", description: "Steam sofa washing and guaranteed stain removal service.", price: "$60", location: "New York, Brooklyn", category: "Cleaning", subcategory: "Sofa", images: ["sofa.fill", "drop.fill"], rating: 4.8, reviewCount: 89, isFeatured: true, reviews: standardReviews),
        ServiceItem(title: "Post-Construction Cleaning", description: "Cleaning tough construction and paint residues.", price: "$350", location: "Texas, Austin", category: "Cleaning", subcategory: "Construction", images: ["hammer.fill", "sparkles"], rating: 4.6, reviewCount: 22),
        ServiceItem(title: "Window Cleaning", description: "Exterior and high-rise building window cleaning.", price: "$150", location: "Illinois, Chicago", category: "Cleaning", subcategory: "Window", images: ["window.shade.closed", "sparkles"], rating: 4.9, reviewCount: 67),
        
        // REPAIR
        ServiceItem(title: "Emergency Plumber", description: "24/7 water leak detection and repair service. Finding faults without breaking using camera systems.", price: "$50", location: "New York, Queens", category: "Repair", subcategory: "Plumbing", images: ["wrench.adjustable.fill", "drop.fill"], rating: 4.8, reviewCount: 210, isFeatured: true, reviews: premiumReviews),
        ServiceItem(title: "Boiler Maintenance & Repair", description: "Combi radiator cleaning and annual maintenance before winter.", price: "$80", location: "Washington, Seattle", category: "Repair", subcategory: "Boiler", images: ["flame.fill", "wrench.fill"], rating: 4.5, reviewCount: 134),
        ServiceItem(title: "Appliance Repair", description: "Refrigerator, washing machine repair. Original parts guarantee.", price: "$40", location: "Florida, Miami", category: "Repair", subcategory: "Appliance", images: ["washer.fill", "wrench.fill"], rating: 4.7, reviewCount: 92),
        ServiceItem(title: "Electrical Fault", description: "Fast electrician for socket, switch, fuse faults.", price: "$30", location: "Colorado, Denver", category: "Repair", subcategory: "Electrical", images: ["bolt.fill", "lightbulb.fill"], rating: 4.9, reviewCount: 156),
        ServiceItem(title: "Furniture Assembly", description: "Professional assembly of your disassembled furniture like IKEA.", price: "$35", location: "New York, Manhattan", category: "Repair", subcategory: "Assembly", images: ["hammer.fill", "bed.double.fill"], rating: 4.8, reviewCount: 112, reviews: standardReviews),
        
        // MOVING
        ServiceItem(title: "Elevator Home Moving", description: "Your belongings are transported insured and packaged. Elevator option up to 15th floor.", price: "$1200", location: "New York, Staten Island", category: "Moving", subcategory: "Home", images: ["box.truck.fill", "shippingbox.fill"], rating: 4.9, reviewCount: 340, isFeatured: true, reviews: premiumReviews),
        ServiceItem(title: "Intercity Transport", description: "Insured transport service across the country.", price: "$2500", location: "Nevada, Las Vegas", category: "Moving", subcategory: "Intercity", images: ["truck.box.fill", "map.fill"], rating: 4.7, reviewCount: 88),
        ServiceItem(title: "Partial Item Moving", description: "Affordable moving for your few items.", price: "$150", location: "Arizona, Phoenix", category: "Moving", subcategory: "Partial", images: ["car.fill", "shippingbox.fill"], rating: 4.5, reviewCount: 45),
        ServiceItem(title: "Office Relocation", description: "Professional and fast office moving service for companies.", price: "$1800", location: "Georgia, Atlanta", category: "Moving", subcategory: "Office", images: ["briefcase.fill", "box.truck.fill"], rating: 4.8, reviewCount: 67),
        
        // DIGITAL & LESSONS
        ServiceItem(title: "Premium Web Design", description: "Modern, fast, and SEO-friendly website creation for your business.", price: "$1500", location: "Remote", category: "Digital", subcategory: "Web", images: ["laptopcomputer", "network"], rating: 5.0, reviewCount: 56, isFeatured: true, reviews: premiumReviews),
        ServiceItem(title: "Social Media Management", description: "Professional management of your Instagram and TikTok accounts.", price: "$500/Mo", location: "Remote", category: "Digital", subcategory: "Social", images: ["iphone", "heart.fill"], rating: 4.8, reviewCount: 120),
        ServiceItem(title: "Private English Lesson", description: "Online speaking-focused lesson from a native speaker.", price: "$40/Hr", location: "Remote", category: "Lessons", subcategory: "Language", images: ["text.book.closed.fill", "mic.fill"], rating: 4.9, reviewCount: 230, reviews: standardReviews),
        ServiceItem(title: "Math Tutoring", description: "Lesson from an experienced teacher for exam preparation.", price: "$50/Hr", location: "California, San Francisco", category: "Lessons", subcategory: "Math", images: ["function", "pencil.and.outline"], rating: 4.7, reviewCount: 78),
        
        // EVENTS & BEAUTY
        ServiceItem(title: "Wedding Photographer", description: "Immortalize your special day. Includes outdoor shoot, drone shoot, and clip.", price: "$1000", location: "Hawaii, Honolulu", category: "Events", subcategory: "Photography", images: ["camera.fill", "sparkles", "heart.fill"], rating: 5.0, reviewCount: 145, isFeatured: true, reviews: premiumReviews),
        ServiceItem(title: "Birthday Organization", description: "Concept party, balloon decoration, and clown service.", price: "$400", location: "New York, Bronx", category: "Events", subcategory: "Party", images: ["party.popper.fill", "balloon.fill"], rating: 4.8, reviewCount: 56),
        ServiceItem(title: "Bridal Hair & Makeup", description: "Professional bridal makeup coming to your home or salon.", price: "$350", location: "California, Los Angeles", category: "Beauty", subcategory: "Makeup", images: ["paintbrush.fill", "star.fill"], rating: 4.9, reviewCount: 89, isFeatured: true),
        ServiceItem(title: "Laser Epilation Campaign", description: "Full body ice laser with guaranteed end.", price: "$200", location: "New York, Upper East Side", category: "Beauty", subcategory: "Epilation", images: ["sparkles", "hand.raised.fill"], rating: 4.7, reviewCount: 312, reviews: standardReviews),
        
        // AUTO
        ServiceItem(title: "Auto Appraisal", description: "Don't be mistaken when buying a 2nd hand car. Mobile appraisal service.", price: "$100", location: "Massachusetts, Boston", category: "Auto", subcategory: "Appraisal", images: ["car.fill", "magnifyingglass"], rating: 4.8, reviewCount: 198),
        ServiceItem(title: "Ceramic Coating", description: "Let your car shine like the first day. 3 years warranty.", price: "$500", location: "Pennsylvania, Philadelphia", category: "Auto", subcategory: "Care", images: ["car.fill", "sparkles"], rating: 4.9, reviewCount: 76, isFeatured: true),
        ServiceItem(title: "Battery Jump & Towing", description: "24/7 emergency auto rescue for stranded vehicles.", price: "$80", location: "Oregon, Portland", category: "Auto", subcategory: "Emergency", images: ["bolt.car.fill", "exclamationmark.triangle.fill"], rating: 4.6, reviewCount: 432),
        
        // HEALTH & OTHERS
        ServiceItem(title: "Home Patient Care", description: "Home serum and injection service from certified nurses.", price: "$100", location: "New York, Manhattan", category: "Health", subcategory: "Care", images: ["cross.case.fill", "heart.fill"], rating: 5.0, reviewCount: 54, reviews: premiumReviews),
        ServiceItem(title: "Dog Trainer", description: "Basic and advanced obedience training. Positive training methods.", price: "$800", location: "New York, Central Park", category: "Others", subcategory: "Pets", images: ["pawprint.fill", "star.fill"], rating: 4.8, reviewCount: 65),
        ServiceItem(title: "Personal Trainer (PT)", description: "One-on-one fitness and nutrition coaching.", price: "$400/Mo", location: "California, San Diego", category: "Health", subcategory: "Sports", images: ["figure.run", "heart.fill"], rating: 4.9, reviewCount: 122, isFeatured: true)
    ]
    
    public static let services: [ServiceItem] = {
        var expanded: [ServiceItem] = baseServices
        let prefixes = ["Premium", "Express", "Pro", "Elite", "Affordable", "24/7"]
        let cities = ["New York", "Los Angeles", "Chicago", "Houston", "Phoenix", "Philadelphia", "San Antonio", "San Diego", "Dallas", "San Jose", "Austin", "Jacksonville", "Fort Worth", "Columbus", "Charlotte", "San Francisco", "Indianapolis", "Seattle", "Denver", "Washington"]
        
        for base in baseServices {
            // Create 10 variations of each base service to reach ~240 items
            for i in 1...10 {
                let randomPrefix = prefixes.randomElement() ?? "Premium"
                let randomCity = cities.randomElement() ?? "New York"
                let randomPrice = Int.random(in: 30...2000)
                let randomRating = Double.random(in: 3.5...5.0)
                let randomReviewCount = Int.random(in: 5...500)
                
                let title = "\(randomPrefix) \(base.title)"
                let location = base.location == "Remote" ? "Remote" : "\(randomCity), USA"
                let priceStr = base.price.contains("/Mo") ? "$\(randomPrice)/Mo" : (base.price.contains("/Hr") ? "$\(randomPrice)/Hr" : "$\(randomPrice)")
                
                let variation = ServiceItem(
                    title: title,
                    description: base.description,
                    price: priceStr,
                    location: location,
                    category: base.category,
                    subcategory: base.subcategory,
                    images: base.images,
                    rating: randomRating,
                    reviewCount: randomReviewCount,
                    isFeatured: false, // Don't feature the generated ones to keep the hero banner clean
                    pricingOptions: base.pricingOptions,
                    reviews: base.reviews
                )
                expanded.append(variation)
            }
        }
        return expanded.shuffled()
    }()
}
