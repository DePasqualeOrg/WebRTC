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
            url: "https://github.com/DePasqualeOrg/WebRTC/releases/download/145.0.0/WebRTC-M145.xcframework.zip",
            checksum: "39c21bffb14b06212099d409c90551d6e153d4f8cc7e355b4c605e0824bbedcf"
        ),
    ]
)
