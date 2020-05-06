// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "SwiftyXMLParser",
    platforms: [.iOS(.v8), .macOS(.v10_10)],
    products: [
        .library(name: "SwiftyXMLParser", targets: ["SwiftyXMLParser"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "SwiftyXMLParser", dependencies: [], path: "SwiftyXMLParser"),
        .testTarget(name: "SwiftyXMLParserTests", dependencies: ["SwiftyXMLParser"], path: "SwiftyXMLParserTests")
    ]
)
