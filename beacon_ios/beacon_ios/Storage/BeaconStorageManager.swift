//
//  BeaconStorageManager.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import Foundation

private enum Constant {
   static let key: String = "storeBeacon"
}


class BeaconStorageManager {

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func saveBeacons( beacons: [Beacon]) {
        if let encoded = try? encoder.encode(beacons) {
            UserDefaults.standard.set(encoded, forKey: Constant.key)
        }
    }

    func loadBeacons() -> [Beacon] {
        guard let encoded = UserDefaults.standard.data(forKey: Constant.key) else {
            return []
        }
        if let decoded = try? decoder.decode([Beacon].self, from: encoded) {
            return decoded
        }
        return []
    }
}
