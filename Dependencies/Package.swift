// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Dependencies",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "Dependencies",
            targets: ["Dependencies"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.10.2"),
        .package(url: "https://github.com/hyperoslo/Cache.git", from: "7.4.0"),
        .package(url: "https://github.com/CoderMJLee/MJRefresh.git", from: "3.7.9"),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.20.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
    ],
    targets: [
        .target(
            name: "Dependencies",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Cache", package: "Cache"),
                .product(name: "MJRefresh", package: "MJRefresh"),
                .product(name: "SDWebImage", package: "SDWebImage"),
                .product(name: "SnapKit", package: "SnapKit"),
            ]
        ),
    ]
)
