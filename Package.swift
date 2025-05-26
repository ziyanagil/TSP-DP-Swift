// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TSP",
    products: [
        .executable(name: "TSP", targets: ["TSP"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TSP",
            dependencies: []
        ),
    ]
)