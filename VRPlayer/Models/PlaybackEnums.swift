import Foundation

enum ProjectionMode: String, Codable, CaseIterable, Identifiable {
    case flat
    case vr180
    case vr360

    var id: String { rawValue }

    var title: String {
        switch self {
        case .flat: return "Flat"
        case .vr180: return "VR180"
        case .vr360: return "VR360"
        }
    }
}

enum StereoMode: String, Codable, CaseIterable, Identifiable {
    case mono
    case sbs
    case topBottom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .mono: return "Mono"
        case .sbs: return "Side-by-Side"
        case .topBottom: return "Top-Bottom"
        }
    }
}
