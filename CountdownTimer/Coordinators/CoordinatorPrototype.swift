//
//  CoordinatorPrototype.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/19.
//

import UIKit

protocol CoordinatorPrototype: AnyObject {

    // MARK: Property

    var navigationController: UINavigationController? { get set }
    var rootViewController: UIViewController? { get }
    var identifier: UUID { get }
    var childCoordinators: [UUID: CoordinatorPrototype] { get set }

    // MARK: Function

    func start()
    func stop()
    func store(coordinator: CoordinatorPrototype)
    func release(coordinator: CoordinatorPrototype)
}
