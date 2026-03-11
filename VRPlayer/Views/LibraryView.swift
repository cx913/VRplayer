import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var container: AppContainer

    var body: some View {
        List {
            ForEach(container.libraryStore.items) { item in
                NavigationLink {
                    PlayerView(mediaItem: item)
                } label: {
                    VideoRowView(item: item, isFavorite: container.favoritesStore.contains(item.id))
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        container.favoritesStore.toggle(item.id)
                    } label: {
                        Label("Favorite", systemImage: container.favoritesStore.contains(item.id) ? "heart.slash" : "heart")
                    }
                    .tint(.pink)
                }
            }
        }
        .navigationTitle("Local Library")
    }
}
