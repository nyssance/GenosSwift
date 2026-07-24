// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import AVKit
import SwiftUI

/// Full-screen vertical video pager: native ScrollView paging, one looping
/// AVPlayer per page, only the visible page plays.
struct ForYouView: View {
  @State private var currentId: Int?

  var body: some View {
    ScrollView(.vertical) {
      LazyVStack(spacing: 0) {
        ForEach(clips) { clip in
          ClipPage(clip: clip, playing: currentId == clip.id)
            .containerRelativeFrame(.vertical)
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.paging)
    .scrollPosition(id: $currentId)
    .ignoresSafeArea()
    .background(Color.black)
    .onAppear { if currentId == nil { currentId = clips.first?.id } }
    .statusBarHidden()
  }
}

private struct ClipPage: View {
  let clip: Clip
  let playing: Bool

  @State private var player: AVPlayer?

  var body: some View {
    ZStack {
      if let player {
        VideoPlayer(player: player)
          .disabled(true)
      }
      overlay
    }
    .background(Color.black)
    .onAppear {
      let created = AVPlayer(url: URL(string: clip.url)!)
      created.isMuted = false
      player = created
      if playing { loopAndPlay(created) }
    }
    .onDisappear {
      player?.pause()
      player = nil
    }
    .onChange(of: playing) { _, isPlaying in
      guard let player else { return }
      if isPlaying { loopAndPlay(player) } else { player.pause() }
    }
  }

  /// Restart from the top and loop (the repeat mode of the Android sample).
  private func loopAndPlay(_ player: AVPlayer) {
    player.seek(to: .zero)
    player.play()
    NotificationCenter.default.addObserver(
      forName: AVPlayerItem.didPlayToEndTimeNotification, object: player.currentItem,
      queue: .main
    ) { [weak player] _ in
      player?.seek(to: .zero)
      player?.play()
    }
  }

  private var overlay: some View {
    VStack {
      Spacer()
      HStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 6) {
          Text("@\(clip.author)")
            .font(.headline.bold())
          Text(clip.caption)
            .font(.subheadline)
        }
        Spacer()
        VStack(spacing: 24) {
          rail("heart.fill", clip.likes)
          rail("ellipsis.message.fill", clip.comments)
          rail("arrowshape.turn.up.right.fill", "Share")
        }
      }
      .padding(.horizontal, 16)
      .padding(.bottom, 48)
    }
    .foregroundStyle(.white)
  }

  private func rail(_ symbol: String, _ label: String) -> some View {
    VStack(spacing: 4) {
      Image(systemName: symbol)
        .font(.system(size: 30))
      Text(label)
        .font(.footnote.weight(.semibold))
    }
  }
}
