import SwiftUI

public struct PostAdWizardView: View {
    @State private var step = 1
    @State private var serviceTitle = ""
    @State private var showingLaunchAlert = false
    @Namespace private var wizardAnimation
    
    public init() {}
    
    public var body: some View {
        ZStack {
            CosmicBackground()
            
            VStack {
                // Header
                HStack {
                    Text("Launch a Service")
                        .font(Font.antigravityHeading())
                        .foregroundColor(Theme.Colors.primaryText)
                    Spacer()
                    Text("Step \(step) of 4")
                        .font(Font.antigravityBody())
                        .foregroundColor(Theme.Colors.secondaryText)
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                Spacer()
                
                // Floating Wizard Card
                CosmicCard {
                    VStack(alignment: .leading, spacing: 24) {
                        if step == 1 {
                            Text("What service are you offering?")
                                .font(Font.antigravityHeading())
                                .foregroundColor(Theme.Colors.primaryText)
                                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
                            
                            TextField("e.g. Deep Cleaning, iOS Developer", text: $serviceTitle)
                                .font(Font.antigravityBody())
                                .foregroundColor(Theme.Colors.primaryText)
                                .padding()
                                .background(Theme.Colors.surfaceGlass)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Theme.Colors.borderGlow, lineWidth: 1)
                                )
                        } else if step == 2 {
                            Text("Select a Category")
                                .font(Font.antigravityHeading())
                                .foregroundColor(Theme.Colors.primaryText)
                                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
                            
                            let categories = ["Cleaning", "Repair", "Digital", "Moving"]
                            ForEach(categories, id: \.self) { cat in
                                HStack {
                                    Text(cat)
                                        .foregroundColor(Theme.Colors.primaryText)
                                    Spacer()
                                    Image(systemName: "circle")
                                        .foregroundColor(Theme.Colors.electricBlue)
                                }
                                .padding()
                                .background(Theme.Colors.surfaceGlass)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        } else if step == 3 {
                            Text("Upload Holograms (Photos)")
                                .font(Font.antigravityHeading())
                                .foregroundColor(Theme.Colors.primaryText)
                                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
                            
                            HStack {
                                Spacer()
                                VStack(spacing: 12) {
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 40))
                                        .foregroundColor(Theme.Colors.electricBlue)
                                        .float(offset: 4, duration: 2.0)
                                    Text("Tap to upload")
                                        .foregroundColor(Theme.Colors.secondaryText)
                                }
                                Spacer()
                            }
                            .padding(40)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [10]))
                                    .foregroundColor(Theme.Colors.borderGlow)
                            )
                        } else {
                            Text("Ready to launch?")
                                .font(Font.antigravityHeading())
                                .foregroundColor(Theme.Colors.primaryText)
                                .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .move(edge: .top).combined(with: .opacity)))
                            
                            Image(systemName: "rocket.fill")
                                .font(.system(size: 64))
                                .foregroundColor(Theme.Colors.magentaPink)
                                .neonGlow(color: Theme.Colors.magentaPink, radius: 20)
                                .float(offset: 10, duration: 2.0)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 32)
                        }
                    }
                    .animation(Theme.Animation.antigravity, value: step)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Next / Publish Button
                LevitatingButton(title: step < 4 ? "Next Phase" : "Launch Service", icon: step < 4 ? "arrow.right" : "sparkles", isPrimary: true) {
                    if step < 4 {
                        withAnimation(Theme.Animation.antigravity) {
                            step += 1
                        }
                    } else {
                        // Show success alert
                        showingLaunchAlert = true
                    }
                }
                .padding(.bottom, 120)
            }
        }
        .alert("Service Launched! 🚀", isPresented: $showingLaunchAlert) {
            Button("Awesome", role: .cancel) {
                withAnimation(Theme.Animation.antigravity) {
                    step = 1
                    serviceTitle = ""
                }
            }
        } message: {
            Text("Your service is now orbiting the marketplace and is visible to the entire galaxy.")
        }
        .ignoresSafeArea()
    }
}
