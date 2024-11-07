# Tuist, Pin & Flex Layout, RxSwift

## Tuist

### Command Line
```
tuist init --name MyApp // 프로젝트 생성

tuist generate // Xcode 프로젝트 생성

tuist build // 빌드

tuist edit // Project.swift 편집

tuist install // Project, Package 편집후 실행

tuist generate // 종속성 설치후 xcode 실행
```

### Package.swift
```swift
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
```

### Project.swift
```swift
// Project.swift

import ProjectDescription

let project = Project(
    name: "TuistWithRxExample",
    targets: [
        .target(
            name: "TuistWithRxExample",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.TuistWithRxExample",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ]
                ]
            ),
            sources: ["TuistWithRxExample/Sources/**"],
            resources: ["TuistWithRxExample/Resources/**"],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "FlexLayout"),
                .external(name: "PinLayout"),
            ]
        ),
        .target(
            name: "TuistWithRxExampleTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.TuistWithRxExampleTests",
            infoPlist: .default,
            sources: ["TuistWithRxExample/Tests/**"],
            resources: [],
            dependencies: [.target(name: "TuistWithRxExample")]
        ),
    ]
)

```

## Pin & Flex Layout

Pin Layout URL : https://github.com/layoutBox/PinLayout
Flex Layout URL : https://github.com/layoutBox/FlexLayout.git

## RxSwift

RxSwift URL: https://github.com/ReactiveX/RxSwift/tree/main


