import CoreMotion
import Foundation

@MainActor
final class MotionManager: ObservableObject {
    @Published private(set) var yaw: Double = 0
    @Published private(set) var pitch: Double = 0
    @Published private(set) var roll: Double = 0

    private let manager = CMMotionManager()
    private var yawOffset: Double = 0

    func start() {
        guard manager.isDeviceMotionAvailable else { return }
        manager.deviceMotionUpdateInterval = 1.0 / 60.0
        manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let attitude = motion?.attitude else { return }
            yaw = attitude.yaw - yawOffset
            pitch = attitude.pitch
            roll = attitude.roll
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }

    func recenter() {
        yawOffset += yaw
    }
}
