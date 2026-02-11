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
            checksum: "3247bb4ee0b58f05e66ae398735ac5843bfeb1553b671d2cf2086031dbe26789"
        ),
    ]
)
