import SwiftUI

public struct BookingWizardView: View {
    let item: ServiceItem
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDate = Date()
    @State private var selectedTimeSlot: String? = nil
    @State private var notes = ""
    @State private var showingConfirmation = false
    
    let timeSlots = ["09:00 AM", "10:30 AM", "01:00 PM", "02:30 PM", "04:00 PM", "05:30 PM"]
    
    public init(item: ServiceItem) {
        self.item = item
    }
    
    public var body: some View {
        ZStack {
            Theme.Colors.background1.ignoresSafeArea()
            CosmicBackground().opacity(0.8)
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Theme.Colors.primaryText)
                            .padding(14)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("BOOK SERVICE")
                        .font(Font.antigravityHeading().weight(.bold))
                        .foregroundColor(Theme.Colors.primaryText)
                        .tracking(2)
                    
                    Spacer()
                    
                    // Invisible view for symmetry
                    Circle().frame(width: 46, height: 46).opacity(0)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Service Summary
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Theme.Colors.neonGradient)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "sparkles")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title)
                                    .font(Font.antigravityBody().weight(.bold))
                                    .foregroundColor(Theme.Colors.primaryText)
                                    .lineLimit(1)
                                
                                Text(item.price)
                                    .font(.system(size: 14))
                                    .foregroundColor(Theme.Colors.electricBlue)
                            }
                            Spacer()
                        }
                        .padding()
                        .cosmicGlassmorphism(cornerRadius: 24)
                        .padding(.horizontal, 24)
                        
                        // Date Picker Card
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Select Date")
                                .font(Font.antigravityHeading())
                                .foregroundColor(Theme.Colors.primaryText)
                            
                            DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .accentColor(Theme.Colors.electricBlue)
                                .colorScheme(.dark) // Force dark mode for better visibility on cosmic background
                        }
                        .padding(20)
                        .cosmicGlassmorphism(cornerRadius: 28)
                        .padding(.horizontal, 24)
                        
                        // Time Slots
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Available Times")
                                .font(Font.antigravityHeading())
                                .foregroundColor(Theme.Colors.primaryText)
                                .padding(.horizontal, 24)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(timeSlots, id: \.self) { slot in
                                        Button {
                                            withAnimation(.spring()) {
                                                selectedTimeSlot = slot
                                            }
                                        } label: {
                                            Text(slot)
                                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                                .foregroundColor(selectedTimeSlot == slot ? .white : Theme.Colors.primaryText)
                                                .padding(.horizontal, 20)
                                                .padding(.vertical, 12)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(selectedTimeSlot == slot ? Theme.Colors.electricBlue : Color.clear)
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(selectedTimeSlot == slot ? Theme.Colors.electricBlue : Theme.Colors.borderGlow, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        
                        // Notes
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Special Requests")
                                .font(Font.antigravityHeading())
                                .foregroundColor(Theme.Colors.primaryText)
                            
                            TextField("Any notes for the provider?", text: $notes, axis: .vertical)
                                .lineLimit(3...5)
                                .font(Font.antigravityBody())
                                .foregroundColor(Theme.Colors.primaryText)
                                .padding()
                                .background(Theme.Colors.surfaceGlass)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Theme.Colors.borderGlow, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer().frame(height: 120)
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            LevitatingButton(
                title: selectedTimeSlot == nil ? "Select Time" : "Confirm Booking",
                icon: "checkmark",
                isPrimary: selectedTimeSlot != nil
            ) {
                if selectedTimeSlot != nil {
                    showingConfirmation = true
                }
            }
            .disabled(selectedTimeSlot == nil)
            .padding(.bottom, 32)
        }
        .alert("Booking Confirmed! 🚀", isPresented: $showingConfirmation) {
            Button("Awesome", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Your appointment for '\(item.title)' on \(selectedDate.formatted(date: .abbreviated, time: .omitted)) at \(selectedTimeSlot ?? "") has been confirmed.")
        }
    }
}
