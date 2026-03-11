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
            url: "https://github.com/DePasqualeOrg/WebRTC/releases/download/146.0.0/WebRTC-M146.xcframework.zip",
            checksum: "a0eef5f040282ec76e08540c32b015eeeb975edd99733801e3c58c9fcad56852"
        ),
    ]
)
