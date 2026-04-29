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
            url: "https://github.com/DePasqualeOrg/WebRTC/releases/download/147.0.1/WebRTC-M147.xcframework.zip",
            checksum: "fa3b84f2e3a97604dd59f5b3410a8bce5af6cdb5b9e8e33a982f3854913a336a"
        ),
    ]
)
