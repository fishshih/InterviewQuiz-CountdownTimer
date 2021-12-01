// 
//  AddTimerCoordinator.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/22.
//

import UIKit
import RxSwift
import RxCocoa

enum AddTimerCoordinationResult {
    case saveDone
    case dismiss
}

class AddTimerCoordinator: Coordinator<AddTimerCoordinationResult> {

    override func start() {

        let vc = AddTimerViewController()
        navigationController = UINavigationController(rootViewController: vc)
        let viewModel = AddTimerViewModel(
            currentTimerCount: TimerDataStorageHelper.fetchData()?.count ?? 0
        )

        rootViewController = vc
        vc.viewModel = viewModel

        viewModel
            .reaction
            .subscribe(onNext: {
                [weak self] reaction in
                switch reaction {
                case .saveDone:
                    self?.output.accept(.saveDone)
                case .cancel:
                    self?.output.accept(.dismiss)
                }
            })
            .disposed(by: disposeBag)
    }
}
