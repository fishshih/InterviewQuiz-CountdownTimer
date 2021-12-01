// 
//  MainViewModel.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/19.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Reaction

enum MainViewModelReaction {
    case addNewTimer
}

// MARK: - Prototype

protocol MainViewModelInput {
    func addNewTimer()
    func removeTimer(by index: Int)
    func checkIfNeedsToUpdated()
}

protocol MainViewModelOutput {
    var timerModels: Observable<[TimerModel]> { get }
    var currentDate: Observable<Date> { get }
}

protocol MainViewModelPrototype {
    var input: MainViewModelInput { get }
    var output: MainViewModelOutput { get }
}

// MARK: - View model

class MainViewModel: MainViewModelPrototype {

    let reaction = PublishRelay<MainViewModelReaction>()

    var input: MainViewModelInput { self }
    var output: MainViewModelOutput { self }

    init() {
        updateData()
        startTimer()
    }

    private let timer = DispatchSource.makeTimerSource(flags: [], queue: .global()) --> {
        $0.schedule(deadline: .now(), repeating: .seconds(1))
    }

    private var _timerModels = BehaviorRelay<[TimerModel]>(value: [])
    private var _currentDate = BehaviorRelay<Date>(value: Date())

    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension MainViewModel: MainViewModelInput {

    func addNewTimer() {
        reaction.accept(.addNewTimer)
    }

    func removeTimer(by index: Int) {

        var models = _timerModels.value
        models.remove(at: index)

        TimerDataStorageHelper.save(data: models)

        updateData()
    }

    func checkIfNeedsToUpdated() {

        let models = _timerModels.value
        let newModel = fetchData()

        guard models != newModel else { return }

        updateData(newData: newModel)
    }
}

extension MainViewModel: MainViewModelOutput {

    var timerModels: Observable<[TimerModel]> {
        _timerModels.asObservable()
    }

    var currentDate: Observable<Date> {
        _currentDate.asObservable()
    }
}

// MARK: - Private function

private extension MainViewModel {

    func startTimer() {

        timer.setEventHandler { [weak self] in
            self?._currentDate.accept(.init())
        }

        timer.resume()
    }

    func fetchData() -> [TimerModel] {
        TimerDataStorageHelper.fetchData() ?? []
    }

    func updateData(newData: [TimerModel]? = nil) {
        _timerModels.accept(newData ?? fetchData())
    }
}
