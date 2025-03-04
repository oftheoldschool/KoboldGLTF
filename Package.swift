// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KoboldGLTF",
    platforms: [
        .iOS("17.0"),
        .macOS("14.0")
    ],
    products: [
        .library(
            name: "KoboldGLTF",
            targets: ["KoboldGLTF"]),
    ],
    targets: [
        .target(
            name: "KoboldGLTF")
    ]
)
