//
//  SceneDelegate.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = .init(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        guard let window = window else { return }

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    func sceneWillEnterForeground(_ scene: UIScene) { }
    func sceneDidEnterBackground(_ scene: UIScene) { }

    // MARK: Private property

    private(set) var appCoordinator: AppCoordinator?
}
