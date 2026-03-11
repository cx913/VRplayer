import SwiftUI

struct VideoRowView: View {
    let item: MediaItem
    let isFavorite: Bool

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.12))
                .frame(width: 64, height: 40)
                .overlay(Image(systemName: "film").foregroundStyle(.white.opacity(0.8)))

            VStack(alignment: .leading, spacing: 3) {
                Text(item.filename)
                    .font(.subheadline)
                    .lineLimit(1)
                Text(metaText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            if isFavorite {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
            }
        }
        .padding(.vertical, 4)
    }

    private var metaText: String {
        let size = item.fileSizeBytes.map { AppFormatters.bytes.string(fromByteCount: $0) } ?? "Unknown size"
        let duration = item.durationSeconds.flatMap { AppFormatters.duration.string(from: $0) } ?? "--:--"
        return "\(size) • \(duration)"
    }
}
