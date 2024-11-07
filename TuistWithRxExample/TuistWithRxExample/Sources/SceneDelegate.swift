//
//  SceneDelegate.swift
//  TuistWithRxExample
//
//  Created by 정종원 on 11/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Window Scene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
    }
}
