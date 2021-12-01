// 
//  MainCoordinator.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/19.
//

import UIKit
import RxSwift
import RxCocoa

class MainCoordinator: Coordinator<Void> {

    // MARK: - Life cycle

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {

        let vc = MainViewController()
        navigationController = UINavigationController(rootViewController: vc)
        let viewModel = MainViewModel()

        rootViewController = vc
        vc.viewModel = viewModel

        viewModel
            .reaction
            .subscribe(onNext: {
                [weak self] reaction in
                switch reaction {
                case .addNewTimer:
                    self?.showAddTimer()
                }
            })
            .disposed(by: disposeBag)

        updateEvent
            .subscribe(onNext: {
                viewModel.input.checkIfNeedsToUpdated()
            })
            .disposed(by: disposeBag)

        window.rootViewController = navigationController
    }

    // MARK: - Private

    private let window: UIWindow
    private let updateEvent = PublishRelay<Void>()
}

private extension MainCoordinator {

    func showAddTimer() {
        
        let next = AddTimerCoordinator()

        next
            .output
            .subscribe(onNext: {
                [weak self] reaction in
                switch reaction {
                case .saveDone:
                    self?.dismiss(coordinator: next) { [weak self] in
                        self?.updateEvent.accept(())
                    }
                case .dismiss:
                    self?.dismiss(coordinator: next, completion: nil)
                }
            })
            .disposed(by: next.disposeBag)

        presentCoordinator(coordinator: next)
    }
}
