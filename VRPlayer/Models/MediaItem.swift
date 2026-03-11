import Foundation

struct MediaItem: Identifiable, Codable, Equatable {
    let id: UUID
    let filename: String
    let localFilename: String
    let fileSizeBytes: Int64?
    let durationSeconds: Double?
    let importedAt: Date

    init(
        id: UUID = UUID(),
        filename: String,
        localFilename: String,
        fileSizeBytes: Int64?,
        durationSeconds: Double?,
        importedAt: Date = Date()
    ) {
        self.id = id
        self.filename = filename
        self.localFilename = localFilename
        self.fileSizeBytes = fileSizeBytes
        self.durationSeconds = durationSeconds
        self.importedAt = importedAt
    }
}
