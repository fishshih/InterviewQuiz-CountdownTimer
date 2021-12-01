// 
//  MainTimerCollectionViewCell.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class MainTimerCollectionViewCell: UICollectionViewCell {

    // MARK: - Property

    let currentDate = BehaviorRelay<Date?>(value: nil)

    var removeEvent: Observable<Void> {
        removeButton.rx.tap.asObservable()
    }

    var reuseDisposeBag = DisposeBag()

    // MARK: - Life cycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupUI()

        bind()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)

        setupUI()

        bind()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reuseDisposeBag = .init()
    }

    // MARK: - Private property

    private typealias ColorSet = (running: UIColor, stopped: UIColor)
    fileprivate typealias DateStringSet = (hour: String, minute: String, second: String)

    private let cardView = UIView() --> {
        $0.backgroundColor = backgroundColorSet.running
        $0.layer.cornerRadius = 8
    }

    private let titleLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 22, weight: .black)
        $0.textColor = textColorSet.running
        $0.numberOfLines = 0
    }

    private let dateLabel = UILabel() --> {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }

    private let removeButton = UIButton() --> {
        guard let image = UIImage(systemName: "xmark.circle.fill") else { return }
        $0.setImage(image, for: .normal)
    }

    private static let backgroundColorSet: ColorSet = (.white, .init(white: 0.9, alpha: 1))
    private static let textColorSet: ColorSet = (.black, .darkGray)
    private static let baseMargin = MainTimerCollectionViewCellConfigure.margin

    private let timeInterval = BehaviorRelay<TimeInterval?>(value: nil)

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension MainTimerCollectionViewCell {

    func setupUI() {
        configureCardView()
        configureTitleLabel()
        configureDateLabel()
        configureRemoveButton()
    }

    func configureCardView() {

        contentView.addSubview(cardView)

        cardView.snp.makeConstraints {
            $0.top.centerX.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func configureTitleLabel() {

        cardView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(Self.baseMargin)
            $0.trailing.lessThanOrEqualTo(-40)
        }
    }

    func configureDateLabel() {

        cardView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(titleLabel.snp.bottom).offset(Self.baseMargin)
            $0.leading.equalTo(titleLabel)
            $0.trailing.lessThanOrEqualTo(-Self.baseMargin)
            $0.bottom.equalTo(-Self.baseMargin)
            $0.height.equalTo(22)
        }
    }

    func configureRemoveButton() {

        cardView.addSubview(removeButton)

        removeButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(40)
        }
    }
}

// MARK: - Public func

extension MainTimerCollectionViewCell {

    func set(name: String?) {
        titleLabel.text = name
    }

    func set(timeInterval: TimeInterval) {
        self.timeInterval.accept(timeInterval)
    }
}

// MARK: - Private func

private extension MainTimerCollectionViewCell {

    static func parse(by currentDate: Date?, timeInterval: TimeInterval?) -> DateStringSet {

        let defaultSet = ("--", "--", "--")

        guard
            let currentDate = currentDate,
            let timeInterval = timeInterval
        else {
            return defaultSet
        }

        guard checkIfShouldActivated(current: currentDate, targetTimeInterval: timeInterval) else {
            return defaultSet
        }

        let targetDate = Date(timeIntervalSince1970: timeInterval)

        let diffComponents = Calendar
            .current
            .dateComponents(
                [.hour, .minute, .second],
                from: currentDate,
                to: targetDate
            )

        guard
            let hour = diffComponents.hour,
            let minute = diffComponents.minute,
            let second = diffComponents.second
        else {
            return defaultSet
        }

        let hourString = String(format: "%d", hour)
        let minuteString = String(format: "%02d", minute)
        let secondString = String(format: "%02d", second)

        return (hourString, minuteString, secondString)
    }

    static func checkIfShouldActivated(current: Date?, targetTimeInterval: TimeInterval?) -> Bool {

        guard
            let current = current,
            let targetTimeInterval = targetTimeInterval
        else {
            return false
        }

        return current.timeIntervalSince1970 < targetTimeInterval
    }
}

// MARK: - Binding

private extension MainTimerCollectionViewCell {

    func bind() {

        Observable
            .combineLatest(
                currentDate,
                timeInterval
            )
            .map {
                let dateSet = Self.parse(by: $0.0, timeInterval: $0.1)
                return .init(
                    format: "%@ : %@ : %@",
                    dateSet.hour,
                    dateSet.minute,
                    dateSet.second
                )
            }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                currentDate,
                timeInterval
            )
            .map { Self.checkIfShouldActivated(current: $0, targetTimeInterval: $1) }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: {
                [weak self] isShouldActivated in

                guard let self = self else { return }

                let backgrouncColor = isShouldActivated ?
                Self.backgroundColorSet.running : Self.backgroundColorSet.stopped

                self.cardView.backgroundColor = backgrouncColor

                let textColor = isShouldActivated ?
                Self.textColorSet.running : Self.textColorSet.stopped

                self.titleLabel.textColor = textColor
            })
            .disposed(by: disposeBag)
    }
}
