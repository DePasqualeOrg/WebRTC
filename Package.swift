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
            url: "https://github.com/DePasqualeOrg/WebRTC/releases/download/144.0.1/WebRTC-M144.xcframework.zip",
            checksum: "adb4b270b150daf0a457eec06d2865e92c7f61ed57ed73295b7bc8a74997e1bb"
        ),
    ]
)
