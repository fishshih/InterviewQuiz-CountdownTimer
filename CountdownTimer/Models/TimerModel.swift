//
//  TimerModel.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/23.
//

import Foundation

struct TimerModel: Codable, Equatable {
    let name: String
    let targetTimeInterval: TimeInterval
}
