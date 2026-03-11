import AVFoundation
import Foundation

struct ImportedVideoMetadata {
    let localFilename: String
    let sizeBytes: Int64?
    let durationSeconds: Double?
}

enum VideoImportError: Error {
    case unsupportedType
    case failedCopy
}

final class VideoImportService {
    private let videoDirectory: URL

    init() {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        videoDirectory = base.appendingPathComponent("Videos", isDirectory: true)
        try? FileManager.default.createDirectory(at: videoDirectory, withIntermediateDirectories: true)
    }

    func importVideo(from sourceURL: URL) throws -> ImportedVideoMetadata {
        guard sourceURL.pathExtension.lowercased() == "mp4" else {
            throw VideoImportError.unsupportedType
        }

        let didAccess = sourceURL.startAccessingSecurityScopedResource()
        defer { if didAccess { sourceURL.stopAccessingSecurityScopedResource() } }

        let destinationFilename = "\(UUID().uuidString).mp4"
        let destinationURL = videoDirectory.appendingPathComponent(destinationFilename)

        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
        } catch {
            throw VideoImportError.failedCopy
        }

        let attrs = try? FileManager.default.attributesOfItem(atPath: destinationURL.path)
        let fileSize = (attrs?[.size] as? NSNumber)?.int64Value

        let asset = AVURLAsset(url: destinationURL)
        let duration = CMTimeGetSeconds(asset.duration)

        return ImportedVideoMetadata(
            localFilename: destinationFilename,
            sizeBytes: fileSize,
            durationSeconds: duration.isFinite ? duration : nil
        )
    }

    func localVideoURL(localFilename: String) -> URL {
        videoDirectory.appendingPathComponent(localFilename)
    }
}
