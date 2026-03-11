# VRPlayer (iPhone, local-only)

Minimal but polished iPhone VR video player for local MP4 playback.

## Structure

- `VRPlayer/App`: app entry and dependency container
- `VRPlayer/Models`: media, history, playlists, playback settings
- `VRPlayer/Stores`: JSON persistence-backed stores
- `VRPlayer/Services`: local file import service
- `VRPlayer/Player`: motion + SceneKit VR scene creation
- `VRPlayer/Views`: home, library, player, favorites, history, playlists, settings
- `VRPlayer/UI`: reusable cards/rows
- `VRPlayer/Extensions`: formatter helpers

## Notes

- Local playback only (no backend, streaming, ads, subscriptions, analytics, accounts).
- Core playback stack: SwiftUI + AVPlayer + SceneKit + CoreMotion.
- Designed for SBS VR180 first, with VR360 and flat projection support.
