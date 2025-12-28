// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Algorithms", package: "swift-algorithms"),
  .product(name: "Collections", package: "swift-collections"),
]

let package = Package(
    name: "WordleGrep",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WordleGrep",
            targets: ["WordleGrep"]
        ),
    ],
    dependencies: [
        .package(
          url: "https://github.com/apple/swift-algorithms.git",
          .upToNextMajor(from: "1.2.0")),
        .package(
          url: "https://github.com/apple/swift-collections.git",
          .upToNextMajor(from: "1.1.4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WordleGrep",
            dependencies: dependencies
        ),
        .testTarget(
            name: "WordleGrepTests",
            dependencies: ["WordleGrep"]
        ),
    ]
)
