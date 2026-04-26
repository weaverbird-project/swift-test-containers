// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "swift-test-containers",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "TestContainers",
            targets: ["TestContainers"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", branch: "main"),
        // Range covers swift-crypto 3.x and 4.x. Upstream is pinned to
        // `from: "3.0.0"` but the only API used in the package is
        // `Insecure.SHA1.hash(data:)` in `ContainerReuse.swift`, which has
        // been API-stable across both major versions. The wider range lets
        // weaverbird-project consume this alongside swift-crypto 4.x
        // (required for the post-quantum APIs the weaverbird core relies
        // on) without forcing a downgrade. Upstream PR pending.
        .package(url: "https://github.com/apple/swift-crypto.git", "3.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.21.0"),
    ],
    targets: [
        .target(
            name: "TestContainers",
            dependencies: [
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Crypto", package: "swift-crypto", condition: .when(platforms: [.linux, .windows])),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ]
        ),
        .testTarget(
            name: "TestContainersTests",
            dependencies: ["TestContainers"]
        )
    ]
)
