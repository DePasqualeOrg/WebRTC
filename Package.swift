// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "WebRTC",
    platforms: [.iOS(.v10), .macOS(.v10_11)],
    products: [
        .library(
            name: "WebRTC",
            targets: ["WebRTC"]),
    ],
    dependencies: [ ],
    targets: [
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/DePasqualeOrg/WebRTC/releases/download/147.0.0/WebRTC-M147.xcframework.zip",
            checksum: "9aa920621a5f69dd7ccae14f1c011bcc165aaa0cd06790496f8d27c2a1821553"
        ),
    ]
)
