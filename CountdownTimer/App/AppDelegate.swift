//
//  AppDelegate.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        UIWindow(frame: UIScreen.main.bounds)
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        if let window = window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
            window.makeKeyAndVisible()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

    // MARK: Private property

    private(set) var appCoordinator: AppCoordinator?
}
