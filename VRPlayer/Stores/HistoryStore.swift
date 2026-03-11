import Foundation

@MainActor
final class HistoryStore: ObservableObject {
    @Published private(set) var items: [HistoryItem]

    private let fileStore: JSONFileStore
    private let filename = "history.json"

    init(fileStore: JSONFileStore) {
        self.fileStore = fileStore
        items = fileStore.load(filename, as: [HistoryItem].self, defaultValue: [])
    }

    func update(mediaID: UUID, positionSeconds: Double) {
        if let index = items.firstIndex(where: { $0.mediaID == mediaID }) {
            items[index].watchedAt = Date()
            items[index].positionSeconds = positionSeconds
        } else {
            items.append(HistoryItem(mediaID: mediaID, positionSeconds: positionSeconds))
        }
        items.sort { $0.watchedAt > $1.watchedAt }
        fileStore.save(items, filename: filename)
    }
}
