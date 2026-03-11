import AVFoundation
import SceneKit
import SwiftUI
import UIKit

struct PlayerView: View {
    @EnvironmentObject private var container: AppContainer
    let mediaItem: MediaItem

    @StateObject private var motion = MotionManager()
    @State private var player = AVPlayer()
    @State private var settings = PlayerSettings()
    @State private var showSettings = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if settings.splitScreenEnabled {
                HStack(spacing: 0) {
                    EyeSceneView(player: player, settings: settings, eye: .left, motion: motion)
                    EyeSceneView(player: player, settings: settings, eye: .right, motion: motion)
                }
            } else {
                EyeSceneView(player: player, settings: settings, eye: .left, motion: motion)
            }

            VStack {
                HStack {
                    Spacer()
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .padding(10)
                            .background(.thinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding()
                Spacer()
            }

            if showSettings {
                VStack {
                    Spacer()
                    PlaybackSettingsOverlay(settings: $settings) {
                        motion.recenter()
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(mediaItem.filename)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: startPlayback)
        .onDisappear(perform: stopPlayback)
    }

    private func startPlayback() {
        settings = PlayerSettings(
            projectionMode: container.settingsStore.appSettings.defaultProjectionMode,
            stereoMode: container.settingsStore.appSettings.defaultStereoMode,
            horizontalFlip: false,
            verticalFlip: false,
            splitScreenEnabled: true
        )

        let url = container.importService.localVideoURL(localFilename: mediaItem.localFilename)
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        motion.start()
        UIApplication.shared.isIdleTimerDisabled = true
    }

    private func stopPlayback() {
        let seconds = CMTimeGetSeconds(player.currentTime())
        if seconds.isFinite {
            container.historyStore.update(mediaID: mediaItem.id, positionSeconds: seconds)
        }
        player.pause()
        motion.stop()
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

private struct EyeSceneView: View {
    let player: AVPlayer
    let settings: PlayerSettings
    let eye: VREye
    @ObservedObject var motion: MotionManager

    var body: some View {
        SceneView(
            scene: VRSceneFactory.makeScene(
                player: player,
                settings: settings,
                eye: eye,
                yaw: motion.yaw,
                pitch: motion.pitch,
                roll: motion.roll
            ),
            options: [.autoenablesDefaultLighting]
        )
        .ignoresSafeArea()
    }
}
