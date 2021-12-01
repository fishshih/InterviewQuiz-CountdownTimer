// 
//  AddTimerViewController.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class AddTimerViewController: UIViewController {

    // MARK: - Property

    var viewModel: AddTimerViewModelPrototype?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        guard let viewModel = viewModel else { return }

        bind(viewModel)
    }

    // MARK: - Private property

    private let stackView = UIStackView() --> {
        $0.axis = .vertical
        $0.spacing = 16
    }

    private let nameCardView = UIView() --> {
        setupCardView($0)
    }

    private let nameTitleView = UILabel() --> {
        setupTitleLabel($0)
        $0.text = "項目名稱"
    }

    private let nameTextField = UITextField() --> {
        $0.placeholder = "請輸入名稱..."
    }

    private let dateCardView = UIView() --> {
        setupCardView($0)
    }

    private let dateTitleView = UILabel() --> {
        setupTitleLabel($0)
        $0.text = "設定時間"
    }

    private let datePicker = UIDatePicker() --> {
        $0.datePickerMode = .dateAndTime
        $0.preferredDatePickerStyle = .inline
        $0.minimumDate = .init()
    }

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension AddTimerViewController {

    func setupUI() {
        title = "新增"
        view.backgroundColor = .white
        configureNavigation()
        configureStackView()
        configureNameCardView()
        configureNameTitleView()
        configureNameTextField()
        configureDateCardView()
        configureDateTitleView()
        configureDatePicker()
    }

    func configureNavigation() {

        navigationItem.leftBarButtonItem = .init(
            title: "取消",
            primaryAction: .init() { [weak self] _ in
                self?.viewModel?.input.cancel()
            }
        )

        navigationItem.rightBarButtonItem = .init(
            title: "新增",
            primaryAction: .init() { [weak self] _ in
                self?.viewModel?.input.save()
            }
        )
    }

    func configureStackView() {

        view.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalTo(16)
            $0.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }

    func configureNameCardView() {
        stackView.addArrangedSubview(nameCardView)
    }

    func configureNameTitleView() {

        nameCardView.addSubview(nameTitleView)

        nameTitleView.snp.makeConstraints {
            $0.top.leading.equalTo(16)
            $0.trailing.lessThanOrEqualTo(-16)
            $0.height.equalTo(24)
        }
    }

    func configureNameTextField() {

        nameCardView.addSubview(nameTextField)

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(nameTitleView.snp.bottom).offset(8)
            $0.leading.equalTo(nameTitleView)
            $0.trailing.bottom.equalTo(-16)
            $0.height.equalTo(42)
        }
    }

    func configureDateCardView() {
        stackView.addArrangedSubview(dateCardView)
    }

    func configureDateTitleView() {

        dateCardView.addSubview(dateTitleView)

        dateTitleView.snp.makeConstraints {
            $0.top.leading.equalTo(16)
            $0.trailing.lessThanOrEqualTo(-16)
            $0.height.equalTo(24)
        }
    }

    func configureDatePicker() {

        dateCardView.addSubview(datePicker)

        datePicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dateTitleView.snp.bottom).offset(8)
            $0.leading.equalTo(16)
            $0.bottom.equalTo(-16)
        }
    }
}

// MARK: - Private func

private extension AddTimerViewController {

    static func setupCardView(_ view: UIView) {

        let backgroundColorView = UIView() --> {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8
        }

        view.addSubview(backgroundColorView)

        backgroundColorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = .init(width: 0, height: 0)
    }

    static func setupTitleLabel(_ label: UILabel) {
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
    }
}

// MARK: - Binding

private extension AddTimerViewController {

    func bind(_ viewModel: AddTimerViewModelPrototype) {

        nameTextField
            .rx
            .text
            .bind { viewModel.input.set(name: $0) }
            .disposed(by: disposeBag)

        datePicker
            .rx
            .date
            .map { $0.timeIntervalSince1970 }
            .bind { viewModel.input.set(targetTimeInterval: $0) }
            .disposed(by: disposeBag)
    }
}
