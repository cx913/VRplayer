import Foundation

struct Playlist: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var mediaIDs: [UUID]
    let createdAt: Date

    init(id: UUID = UUID(), name: String, mediaIDs: [UUID] = [], createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.mediaIDs = mediaIDs
        self.createdAt = createdAt
    }
}
