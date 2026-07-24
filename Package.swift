// swift-tools-version: 6.2
import PackageDescription

let package = Package(
  name: "Genos",
  platforms: [.iOS(.v26)],
  products: [
    .library(name: "Genos", targets: ["Genos"])
  ],
  dependencies: [
    // Markdown rendering, the ecosystem standard (GFM); code highlighting via Highlightr,
    // the same pair Genos for Android exports (multiplatform-markdown-renderer m3/code).
    .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.0.0"),
    .package(url: "https://github.com/raspu/Highlightr", from: "2.1.0"),
  ],
  targets: [
    .target(
      name: "Genos",
      dependencies: [
        .product(name: "MarkdownUI", package: "swift-markdown-ui"),
        "Highlightr",
      ]),
    .testTarget(name: "GenosTests", dependencies: ["Genos"]),
  ]
)
