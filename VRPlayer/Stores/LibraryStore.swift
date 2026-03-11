import Foundation

@MainActor
final class LibraryStore: ObservableObject {
    @Published private(set) var items: [MediaItem] = []

    private let fileStore: JSONFileStore
    private let filename = "library.json"

    init(fileStore: JSONFileStore) {
        self.fileStore = fileStore
        items = fileStore.load(filename, as: [MediaItem].self, defaultValue: [])
            .sorted(by: { $0.importedAt > $1.importedAt })
    }

    func add(_ item: MediaItem) {
        items.insert(item, at: 0)
        persist()
    }

    func item(for id: UUID) -> MediaItem? {
        items.first(where: { $0.id == id })
    }

    private func persist() {
        fileStore.save(items, filename: filename)
    }
}
