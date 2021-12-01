//
//  TimerDataStorageHelper.swift
//  CountdownTimer
//
//  Created by Fish Shih on 2021/11/23.
//

import Foundation

struct TimerDataStorageHelper {

    // MARK: - Static func

    static func add(model: TimerModel) {
        var models = TimerDataStorageHelper.fetchData() ?? []
        models.append(model)
        save(data: models)
    }

    static func save(data: [TimerModel]) {
        let encodedString = try? encoder.encode(data).base64EncodedString()
        UserDefaults.standard.set(encodedString, forKey: key)
    }

    static func fetchData() -> [TimerModel]? {

        guard
            let encodedString = UserDefaults.standard.string(forKey: key),
            let data = Data(base64Encoded: encodedString)
        else {
            return nil
        }

        return try? decoder.decode([TimerModel].self, from: data)
    }

    // MARK: - Private

    private static let key = "TimerDataStorage"

    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()
}
