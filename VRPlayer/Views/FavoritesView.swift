import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var container: AppContainer

    private var favorites: [MediaItem] {
        container.libraryStore.items.filter { container.favoritesStore.contains($0.id) }
    }

    var body: some View {
        List(favorites) { item in
            NavigationLink {
                PlayerView(mediaItem: item)
            } label: {
                VideoRowView(item: item, isFavorite: true)
            }
        }
        .overlay {
            if favorites.isEmpty {
                ContentUnavailableView("No favorites yet", systemImage: "heart", description: Text("Swipe right on videos in the library to add favorites."))
            }
        }
        .navigationTitle("Favorites")
    }
}
