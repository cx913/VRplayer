import Foundation

@MainActor
final class AppContainer: ObservableObject {
    let fileStore = JSONFileStore()
    let importService = VideoImportService()

    let libraryStore: LibraryStore
    let favoritesStore: FavoritesStore
    let historyStore: HistoryStore
    let playlistStore: PlaylistStore
    let settingsStore: SettingsStore

    init() {
        libraryStore = LibraryStore(fileStore: fileStore)
        favoritesStore = FavoritesStore(fileStore: fileStore)
        historyStore = HistoryStore(fileStore: fileStore)
        playlistStore = PlaylistStore(fileStore: fileStore)
        settingsStore = SettingsStore(fileStore: fileStore)
    }
}
