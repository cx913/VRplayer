import Foundation

@MainActor
final class SettingsStore: ObservableObject {
    @Published var appSettings: AppSettings {
        didSet { fileStore.save(appSettings, filename: filename) }
    }

    private let fileStore: JSONFileStore
    private let filename = "app-settings.json"

    init(fileStore: JSONFileStore) {
        self.fileStore = fileStore
        appSettings = fileStore.load(filename, as: AppSettings.self, defaultValue: AppSettings())
    }
}
