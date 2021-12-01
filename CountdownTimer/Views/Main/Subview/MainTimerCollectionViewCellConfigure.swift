//
//  MainTimerCollectionViewCellConfigure.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/25.
//

import UIKit

struct MainTimerCollectionViewCellConfigure {

    static let padding = CGFloat(16)
    static let margin = CGFloat(16)
    static let lineSpacing = CGFloat(16)

    static var cellSize: CGSize {
        let width = (UIScreen.main.bounds.width - (margin * 3)) / 2
        return .init(width: width, height: 124)
    }
}
