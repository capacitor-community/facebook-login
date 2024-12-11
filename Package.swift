// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorCommunityFacebookLogin",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "FacebookLogin",
            targets: ["FacebookLogin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", branch: "main",
    ],
    targets: [
        .target(
            name: "FacebookLogin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "FBSDKLoginKit", package: "facebook-ios-sdk"),
            ],
            path: "ios/Sources/FacebookLogin"),
        .testTarget(
            name: "FacebookLoginTests",
            dependencies: ["FacebookLogin"],
            path: "ios/Tests/FacebookLoginTests")
    ]
)
