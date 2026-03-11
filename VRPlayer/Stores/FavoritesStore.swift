import Foundation

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var ids: Set<UUID>

    private let fileStore: JSONFileStore
    private let filename = "favorites.json"

    init(fileStore: JSONFileStore) {
        self.fileStore = fileStore
        ids = fileStore.load(filename, as: Set<UUID>.self, defaultValue: [])
    }

    func contains(_ id: UUID) -> Bool {
        ids.contains(id)
    }

    func toggle(_ id: UUID) {
        if ids.contains(id) { ids.remove(id) } else { ids.insert(id) }
        fileStore.save(ids, filename: filename)
    }
}
