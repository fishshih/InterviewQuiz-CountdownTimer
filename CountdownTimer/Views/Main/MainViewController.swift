// 
//  MainViewController.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/19.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    // MARK: - Property

    var viewModel: MainViewModelPrototype?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        guard let viewModel = viewModel else { return }

        bind(viewModel)
    }

    // MARK: - Private property

    private var collectionView: UICollectionView?

    private var timerModels = [TimerModel]() {
        didSet {
            collectionView?.reloadData()
        }
    }

    private let disposeBag = DisposeBag()
}

// MARK: - UI configure

private extension MainViewController {

    func setupUI() {
        title = "倒數計時"
        view.backgroundColor = .white
        configureNavigation()
        configureCollectionView()
    }

    func configureNavigation() {
        navigationItem.rightBarButtonItem = .init(
            systemItem: .add,
            primaryAction: .init() { [weak self] _ in
                self?.viewModel?.input.addNewTimer()
            }
        )
    }

    func configureCollectionView() {

        let flowLayout = UICollectionViewFlowLayout()
        let padding = MainTimerCollectionViewCellConfigure.padding

        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumLineSpacing = MainTimerCollectionViewCellConfigure.lineSpacing
        flowLayout.itemSize = MainTimerCollectionViewCellConfigure.cellSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.collectionView = collectionView

//        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.register(MainTimerCollectionViewCell.self)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.backgroundColor = .clear
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowRadius = 2
        collectionView.layer.shadowOpacity = 0.6
        collectionView.layer.shadowOffset = .init(width: 0, height: 0)

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Private func

private extension MainViewController {

}

// MARK: - Binding

private extension MainViewController {

    func bind(_ viewModel: MainViewModelPrototype) {

        viewModel
            .output
            .timerModels
            .subscribe(onNext: {
                [weak self] in
                self?.timerModels = $0
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        timerModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = MainTimerCollectionViewCell.use(collection: collectionView, for: indexPath)
        let model = timerModels[indexPath.item]

        cell.set(name: model.name)
        cell.set(timeInterval: model.targetTimeInterval)

        viewModel?
            .output
            .currentDate
            .bind(to: cell.currentDate)
            .disposed(by: cell.reuseDisposeBag)

        cell
            .removeEvent
            .subscribe(onNext: {
                [weak self] _ in
                self?.viewModel?.input.removeTimer(by: indexPath.item)
            })
            .disposed(by: cell.reuseDisposeBag)

        return cell
    }
}
