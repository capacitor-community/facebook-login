// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorCommunityFacebookLogin",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CapacitorCommunityFacebookLogin",
            targets: ["FacebookLoginPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", .upToNextMajor(from: "17.4.0"))
    ],
    targets: [
        .target(
            name: "FacebookLoginPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk")
            ],
            path: "ios/Sources/FacebookLoginPlugin"),
        .testTarget(
            name: "FacebookLoginPluginTests",
            dependencies: ["FacebookLoginPlugin"],
            path: "ios/Tests/FacebookLoginPluginTests")
    ]
)
