// SPDX-FileCopyrightText: 2020-2026 NY <nyssance@icloud.com>
// SPDX-License-Identifier: Apache-2.0

import Foundation

/// Public test videos: Blender open movies via test-videos.co.uk, plus Google's ExoPlayer test media.
struct Clip: Identifiable {
  let id: Int
  let url: String
  let author: String
  let caption: String
  let likes: String
  let comments: String
}

private let testVideos = "https://test-videos.co.uk/vids"

let clips = [
  Clip(
    id: 1,
    url: "\(testVideos)/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_5MB.mp4",
    author: "blender", caption: "Big Buck Bunny — the classic 🐰", likes: "128K", comments: "2,041"),
  Clip(
    id: 2,
    url: "\(testVideos)/jellyfish/mp4/h264/720/Jellyfish_720_10s_5MB.mp4",
    author: "oceanlife", caption: "Jellyfish vibes 🪼", likes: "96K", comments: "1,312"),
  Clip(
    id: 3,
    url: "\(testVideos)/sintel/mp4/h264/720/Sintel_720_10s_5MB.mp4",
    author: "blender", caption: "Sintel ✨", likes: "87K", comments: "954"),
  Clip(
    id: 4,
    url: "https://storage.googleapis.com/exoplayer-test-media-1/mp4/android-screens-10s.mp4",
    author: "android", caption: "Android screens 🤖", likes: "64K", comments: "701"),
]
