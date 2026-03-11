import SwiftUI

struct PlaylistsView: View {
    @EnvironmentObject private var container: AppContainer
    @State private var playlistName = ""

    var body: some View {
        List {
            Section("Create") {
                HStack {
                    TextField("New playlist", text: $playlistName)
                    Button("Add") {
                        container.playlistStore.create(name: playlistName)
                        playlistName = ""
                    }
                }
            }

            Section("Your Playlists") {
                ForEach(container.playlistStore.playlists) { playlist in
                    NavigationLink {
                        PlaylistDetailView(playlistID: playlist.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(playlist.name)
                            Text("\(playlist.mediaIDs.count) videos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Playlists")
    }
}

private struct PlaylistDetailView: View {
    @EnvironmentObject private var container: AppContainer
    let playlistID: UUID

    var playlist: Playlist? {
        container.playlistStore.playlists.first(where: { $0.id == playlistID })
    }

    var body: some View {
        List {
            if let playlist {
                ForEach(playlist.mediaIDs, id: \.self) { mediaID in
                    if let item = container.libraryStore.item(for: mediaID) {
                        NavigationLink {
                            PlayerView(mediaItem: item)
                        } label: {
                            VideoRowView(item: item, isFavorite: container.favoritesStore.contains(item.id))
                        }
                    }
                }

                Section("Add from Library") {
                    ForEach(container.libraryStore.items) { item in
                        Button(item.filename) {
                            container.playlistStore.add(mediaID: item.id, to: playlistID)
                        }
                    }
                }
            }
        }
        .navigationTitle(playlist?.name ?? "Playlist")
    }
}
