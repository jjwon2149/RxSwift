// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
import struct ProjectDescription.PackageSettings

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    // productTypes: ["Alamofire": .framework,]
    productTypes: [:]
)
#endif

let package = Package(
    name: "TuistWithRxExample",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/layoutBox/FlexLayout", from: "1.3.18"),
        .package(url: "https://github.com/layoutBox/PinLayout", from: "1.10.5"),
        
        
        
    ],
    targets: [
        .target(name: "TuistWithRxExample", dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift")]),

    ]
)
