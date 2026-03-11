import Foundation

struct HistoryItem: Identifiable, Codable, Equatable {
    let id: UUID
    let mediaID: UUID
    var watchedAt: Date
    var positionSeconds: Double

    init(id: UUID = UUID(), mediaID: UUID, watchedAt: Date = Date(), positionSeconds: Double) {
        self.id = id
        self.mediaID = mediaID
        self.watchedAt = watchedAt
        self.positionSeconds = positionSeconds
    }
}
