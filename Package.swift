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
            url: "https://github.com/DePasqualeOrg/WebRTC/releases/download/148.0.0/WebRTC-M148.xcframework.zip",
            checksum: "be44810fb0afdce9f0f7217bdd138e05c3704fd16fe88d1a8547141aed5ce510"
        ),
    ]
)
