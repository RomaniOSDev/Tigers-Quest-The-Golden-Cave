//
//  SceneDelegate.swift
//  Tigers Quest: The Golden Cave
//
//  Created by Roman on 11/9/26.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let host = UIHostingController(rootView: RootView())
        host.view.backgroundColor = UIColor(red: 0.07, green: 0.03, blue: 0.015, alpha: 1)
        window.rootViewController = host
        window.backgroundColor = UIColor(red: 0.07, green: 0.03, blue: 0.015, alpha: 1)
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
