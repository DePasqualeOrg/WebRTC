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
            url: "https://github.com/stasel/WebRTC/releases/download/144.0.0/WebRTC-M144.xcframework.zip",
            checksum: "ed0fa2c26545583bf6fea8851045b5e9d0b780d020b69a44e12cbe75999df652"
        ),
    ]
)
