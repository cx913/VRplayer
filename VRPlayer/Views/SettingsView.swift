import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var container: AppContainer

    var body: some View {
        Form {
            Picker("Default Projection", selection: $container.settingsStore.appSettings.defaultProjectionMode) {
                ForEach(ProjectionMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }

            Picker("Default Stereo", selection: $container.settingsStore.appSettings.defaultStereoMode) {
                ForEach(StereoMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
        }
        .navigationTitle("Settings")
    }
}
