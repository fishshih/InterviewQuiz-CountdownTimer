// 
//  AddTimerViewModel.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/22.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Reaction

enum AddTimerViewModelReaction {
    case saveDone
    case cancel
}

// MARK: - Prototype

protocol AddTimerViewModelInput {
    func set(name: String?)
    func set(targetTimeInterval: TimeInterval)
    func save()
    func cancel()
}

protocol AddTimerViewModelOutput {
    var defaultTimeInterval: TimeInterval { get }
}

protocol AddTimerViewModelPrototype {
    var input: AddTimerViewModelInput { get }
    var output: AddTimerViewModelOutput { get }
}

// MARK: - View model

class AddTimerViewModel: AddTimerViewModelPrototype {

    let reaction = PublishRelay<AddTimerViewModelReaction>()

    var input: AddTimerViewModelInput { self }
    var output: AddTimerViewModelOutput { self }

    init(currentTimerCount: Int) {
        self.currentTimerCount = currentTimerCount

    }

    private let currentTimerCount: Int
    private var name: String?
    private lazy var timeInterval = { _defaultTimeInterval }()
    private let _defaultTimeInterval = Date().timeIntervalSince1970

    private let numFormatter = NumberFormatter() --> {
        $0.locale = .init(identifier: "zh_TW")
        $0.numberStyle = .spellOut
    }

    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension AddTimerViewModel: AddTimerViewModelInput {

    func set(name: String?) {
        self.name = name
    }

    func set(targetTimeInterval: TimeInterval) {
        timeInterval = targetTimeInterval
    }

    func save() {

        var models = TimerDataStorageHelper.fetchData() ?? []
        models.append(makeModel())
        TimerDataStorageHelper.save(data: models)

        reaction.accept(.saveDone)
    }

    func cancel() {
        reaction.accept(.cancel)
    }
}

extension AddTimerViewModel: AddTimerViewModelOutput {

    var defaultTimeInterval: TimeInterval {
        _defaultTimeInterval
    }
}

// MARK: - Private function

private extension AddTimerViewModel {

    func getDefaultName() -> String {
        let num = NSNumber(value: currentTimerCount + 1)
        let count = numFormatter.string(from: num) ?? String(currentTimerCount)
        return "項目" + count
    }

    func makeModel() -> TimerModel {

        var name: String {
            guard let name = self.name else {
                return getDefaultName()
            }
            return name.isEmpty ? getDefaultName() : name
        }

        return .init(name: name, targetTimeInterval: timeInterval)
    }
}
