import Foundation

struct PlayerSettings: Codable, Equatable {
    var projectionMode: ProjectionMode = .vr180
    var stereoMode: StereoMode = .sbs
    var horizontalFlip: Bool = false
    var verticalFlip: Bool = false
    var splitScreenEnabled: Bool = true
}

struct AppSettings: Codable, Equatable {
    var defaultProjectionMode: ProjectionMode = .vr180
    var defaultStereoMode: StereoMode = .sbs
}
