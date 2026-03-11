import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var isImporterPresented = false
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                importButton

                NavigationLink { LibraryView() } label: {
                    SectionCard(title: "Local Library", subtitle: "Imported videos", icon: "film.stack")
                }
                NavigationLink { FavoritesView() } label: {
                    SectionCard(title: "Favorites", subtitle: "Quick access picks", icon: "heart.fill")
                }
                NavigationLink { HistoryView() } label: {
                    SectionCard(title: "History", subtitle: "Continue watching", icon: "clock.arrow.circlepath")
                }
                NavigationLink { PlaylistsView() } label: {
                    SectionCard(title: "Playlists", subtitle: "Group videos", icon: "music.note.list")
                }
                NavigationLink { SettingsView() } label: {
                    SectionCard(title: "Settings", subtitle: "Default playback modes", icon: "gearshape.fill")
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Home")
        .fileImporter(isPresented: $isImporterPresented, allowedContentTypes: [UTType.mpeg4Movie], allowsMultipleSelection: false) { result in
            handleImport(result)
        }
        .alert("Import Error", isPresented: Binding(get: { errorMessage != nil }, set: { _ in errorMessage = nil })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
    }

    private var importButton: some View {
        Button {
            isImporterPresented = true
        } label: {
            SectionCard(title: "Import Video", subtitle: "Pick an MP4 from Files", icon: "square.and.arrow.down")
        }
        .buttonStyle(.plain)
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        do {
            guard let url = try result.get().first else { return }
            let metadata = try container.importService.importVideo(from: url)
            let item = MediaItem(
                filename: url.lastPathComponent,
                localFilename: metadata.localFilename,
                fileSizeBytes: metadata.sizeBytes,
                durationSeconds: metadata.durationSeconds
            )
            container.libraryStore.add(item)
        } catch {
            errorMessage = "Could not import this video. Please use a local MP4 file."
        }
    }
}
