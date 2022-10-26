//
//  BeaconContactsSummary.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import Foundation

public struct BeaconContactsSummary {
    
    public let name: String
    public let uuid: String
    public let major: String
    public let minor: String
    public let rssi: Double?
    public let averageRSSI: Double?
    public let timestamp: Int?
    public let frequency: Int
    /// Contact count
    public let contactCount: Int
    /// Returns if beacon is in range
    public let isInRange: Bool

    private let beacon: Beacon
    private let events: [EventModel]

    init(beacon: Beacon, events: [EventModel], isInRange: Bool) {
        self.beacon = beacon
        self.events = events
        self.isInRange = isInRange

        self.name = beacon.name ?? ""
        self.uuid = beacon.uuid
        self.major = "\(beacon.major)"
        self.minor = "\(beacon.minor)"
        self.contactCount = events.count

        let firstEvent = events.sorted { ($0.timestamp) ?? 0 < ($1.timestamp ?? 0) }.first
        let lastEvent = events.sorted { ($0.timestamp ?? 0) > ($1.timestamp ?? 0) }.first
        if
            let lastTime = lastEvent?.timestamp,
            let firstTime = firstEvent?.timestamp,
            firstTime < lastTime
        {
            frequency = Int(Float(Float((Float(lastTime - firstTime) / Float(contactCount)) / 1000) * 60))
        } else {
            frequency = 0
        }

        timestamp = lastEvent?.timestamp
        rssi = lastEvent?.rssi

        if events.count > 0 {
            averageRSSI = events.reduce(into: 0) { result, event in
                result += event.rssi ?? 0
            } / Double(events.count)
        } else {
            averageRSSI = nil
        }
    }
}

