// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "EinstoreCore",
    products: [
        .library(name: "EinstoreCore", targets: ["EinstoreCore"]),
        .library(name: "EinstoreCoreTestTools", targets: ["EinstoreCoreTestTools"]),
        .executable(name: "AppHost", targets: ["AppHost"])
    ],
    dependencies: [
        .package(name: "Vapor", url: "https://github.com/vapor/vapor.git", from: "3.3.1"),
        .package(name: "Fluent", url: "https://github.com/vapor/fluent.git", from: "3.2.1"),
        .package(name: "FluentPostgreSQL", url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        .package(url: "https://github.com/kareman/SwiftShell.git", from: "5.1.0"),
        .package(url: "https://github.com/lynnzc/S3.git", from: "3.0.1"),
        .package(url: "https://github.com/LiveUI/ErrorsCore.git", from: "0.1.0"),
        .package(url: "https://github.com/lynnzc/ApiCore.git", .branch("master")),
        .package(url: "https://github.com/lynnzc/MailCore.git", .branch("master")),
        .package(url: "https://github.com/LiveUI/VaporTestTools.git", from: "0.1.5"),
        .package(url: "https://github.com/LiveUI/FluentTestTools.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-nio-zlib-support.git", from: "1.0.0"),
        .package(url: "https://github.com/IBM-Swift/LoggerAPI.git", .upToNextMinor(from: "1.8.1"))
    ],
    targets: [
        .target(name: "Czlib"),
        .target(
            name: "Normalized",
            dependencies: [
                "Czlib"
            ]
        ),
        .target(
            name: "EinstoreApp",
            dependencies: [
                "Vapor",
                "EinstoreCore"
            ]
        ),
        .target(
            name: "AppHost",
            dependencies: [
                "EinstoreApp"
            ]
        ),
        .target(
            name: "EinstoreCore",
            dependencies: [
                "Vapor",
                "Fluent",
                "FluentPostgreSQL",
                "ApiCore",
                "ErrorsCore",
                "SwiftShell",
                "MailCore",
                "S3",
                "Normalized"
            ]
        ),
        .target(
            name: "EinstoreCoreTestTools",
            dependencies: [
                "Vapor",
                "ApiCore",
                "EinstoreCore",
                "VaporTestTools",
                .product(name: "ApiCoreTestTools", package: "ApiCore"),
                .product(name: "MailCoreTestTools", package: "MailCore")
            ]
        ),
        .testTarget(
            name: "EinstoreCoreTests",
            dependencies: [
                "EinstoreCore",
                "VaporTestTools",
                "FluentTestTools",
                .product(name: "ApiCoreTestTools", package: "ApiCore"),
                "EinstoreCoreTestTools"
            ]
        )
    ]
)
