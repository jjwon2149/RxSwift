//
//  AppDelegate.swift
//  TuistWithRxExample
//
//  Created by 정종원 on 11/7/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = UIViewController()
        viewController.view.backgroundColor = .orange
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }

}
