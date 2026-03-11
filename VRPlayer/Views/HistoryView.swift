import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var container: AppContainer

    var body: some View {
        List(container.historyStore.items) { history in
            if let item = container.libraryStore.item(for: history.mediaID) {
                NavigationLink {
                    PlayerView(mediaItem: item)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        VideoRowView(item: item, isFavorite: container.favoritesStore.contains(item.id))
                        Text("Last position: \(AppFormatters.duration.string(from: history.positionSeconds) ?? "00:00")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .overlay {
            if container.historyStore.items.isEmpty {
                ContentUnavailableView("No history yet", systemImage: "clock", description: Text("Watched videos will appear here."))
            }
        }
        .navigationTitle("History")
    }
}
