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
