//
//  ContentView.swift
//  Locanto Estate
//
//  Created by Yunus Emre Gürlek on 29.06.2026.
//

import SwiftUI

public struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var currentTab: TabItem = .home
    @State private var isAppReady: Bool = false
    
    public init() {}
    
    public var body: some View {
        Group {
            if !isAppReady {
                LaunchScreenView()
                    .transition(.opacity.combined(with: .scale(scale: 1.1)))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                isAppReady = true
                            }
                        }
                    }
            } else if !hasSeenOnboarding {
                OnboardingView()
            } else {
                ZStack(alignment: .bottom) {
                    // Main Content
                    Group {
                        switch currentTab {
                        case .home:
                            HomeFeedView()
                        case .search:
                            SearchPage()
                        case .post:
                            PostAdWizardView()
                        case .profile:
                            ProfileView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Floating Navigation
                    FloatingTabBar(selectedTab: $currentTab)
                }
            }
        }
        .preferredColorScheme(nil)
    }
}

#Preview {
    ContentView()
}
