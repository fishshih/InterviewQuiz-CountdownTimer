//
//  AppCoordinator.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/19.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: Coordinator<Void> {

    // MARK: - Life cycle

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {

        let next = MainCoordinator(window: window)

        next.start()

        store(coordinator: next)
    }

    // MARK: - Private

    private let window: UIWindow
}
