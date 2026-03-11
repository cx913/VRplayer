import Foundation

@MainActor
final class PlaylistStore: ObservableObject {
    @Published private(set) var playlists: [Playlist]

    private let fileStore: JSONFileStore
    private let filename = "playlists.json"

    init(fileStore: JSONFileStore) {
        self.fileStore = fileStore
        playlists = fileStore.load(filename, as: [Playlist].self, defaultValue: [])
    }

    func create(name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        playlists.insert(Playlist(name: trimmed), at: 0)
        fileStore.save(playlists, filename: filename)
    }

    func add(mediaID: UUID, to playlistID: UUID) {
        guard let index = playlists.firstIndex(where: { $0.id == playlistID }) else { return }
        guard !playlists[index].mediaIDs.contains(mediaID) else { return }
        playlists[index].mediaIDs.append(mediaID)
        fileStore.save(playlists, filename: filename)
    }
}
