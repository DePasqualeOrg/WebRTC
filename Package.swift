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
            url: "https://github.com/DePasqualeOrg/WebRTC/releases/download/146.0.1/WebRTC-M146.xcframework.zip",
            checksum: "0c5a48e49db0bfeba3163920d9d725727b4e047bf98abbc8e28b5f95e2d977ee"
        ),
    ]
)
