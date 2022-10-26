//
//  CLBeacon+Ext.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import CoreLocation

enum Event: String {
    case `in` = "IN"
    case out = "OUT"
}

extension CLBeacon {

    func toEvent(event: Event) -> EventModel {
        let uuidString: String
        var timestamp = Date().millisecondsSince1970
        uuidString = uuid.uuidString
        timestamp = self.timestamp.millisecondsSince1970
        return EventModel(
            event: event.rawValue,
            major: "\(major)",
            minor: "\(minor)",
            uuid: uuidString,
            distance: 0,
            rssi: Double(rssi),
            timestamp: timestamp
        )
    }
}
