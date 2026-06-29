import SwiftUI
import Combine
#if canImport(CoreMotion)
import CoreMotion
#endif

class MotionManager: ObservableObject {
#if os(iOS) && !targetEnvironment(macCatalyst)
    private let motionManager = CMMotionManager()
#endif
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    init() {
        start()
    }
    
    func start() {
#if os(iOS) && !targetEnvironment(macCatalyst)
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1 / 60
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            self?.pitch = motion.attitude.pitch
            self?.roll = motion.attitude.roll
        }
#endif
    }
    
    deinit {
#if os(iOS) && !targetEnvironment(macCatalyst)
        motionManager.stopDeviceMotionUpdates()
#endif
    }
}

struct GyroTiltModifier: ViewModifier {
    @StateObject private var motion = MotionManager()
    var intensity: Double = 10.0
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(motion.pitch * intensity),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
            .rotation3DEffect(
                .degrees(motion.roll * intensity),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
}

extension View {
    public func gyroTilt(intensity: Double = 10.0) -> some View {
        self.modifier(GyroTiltModifier(intensity: intensity))
    }
}
