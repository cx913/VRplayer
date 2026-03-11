import SwiftUI

struct PlaybackSettingsOverlay: View {
    @Binding var settings: PlayerSettings
    let onRecenter: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Playback Settings")
                .font(.headline)

            Picker("Projection", selection: $settings.projectionMode) {
                ForEach(ProjectionMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            Picker("Stereo", selection: $settings.stereoMode) {
                ForEach(StereoMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Split Screen", isOn: $settings.splitScreenEnabled)
            Toggle("Horizontal Flip", isOn: $settings.horizontalFlip)
            Toggle("Vertical Flip", isOn: $settings.verticalFlip)

            Button("Recenter View", action: onRecenter)
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
