//
//  CellExtension.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/25.
//

import UIKit

extension UITableView {
    /// 註冊 Cell
    func register(_ cellClass: AnyClass...) {
        cellClass.forEach {
            self.register($0, forCellReuseIdentifier: String(describing: $0))
        }
    }
}

extension UITableViewCell {
    static func use(table view: UITableView, for index: IndexPath) -> Self {
        return cell(tableView: view, for: index)
    }

    private static func cell<T>(tableView: UITableView, for index: IndexPath) -> T {

        let id = String(describing: self)

        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: index) as? T else {
            assert(false)
        }

        return cell
    }
}

extension UICollectionView {
    /// 註冊 Cell
    func register(_ cellClass: AnyClass...) {
        cellClass.forEach {
            self.register($0, forCellWithReuseIdentifier: String(describing: $0))
        }
    }
}

extension UICollectionViewCell {
    static func use(collection view: UICollectionView, for index: IndexPath) -> Self {
        return cell(collectionView: view, for: index)
    }

    private static func cell<T>(collectionView: UICollectionView, for index: IndexPath) -> T {

        let id = String(describing: self)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: index) as? T else {
            assert(false)
        }

        return cell
    }
}

