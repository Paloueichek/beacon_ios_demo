//
//  Beacon.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import Foundation
import CoreLocation

struct Beacon: Codable, Hashable, CustomStringConvertible {
    
    enum CodingKeys: String, CodingKey {
        case uuid, major, minor, name
    }
    
    let uuid: String
    let major: Int
    let minor: Int
    let name: String?
    
    var isValid: Bool {
        UUID(uuidString: uuid) != nil && major > 0 && minor > 0
    }
    
    var description: String {
        "UUID: \(uuid.lowercased()), Major: \(major),  Minor: \(minor)"
    }
    
    func toRegion(prefix: String) -> CLBeaconRegion? {
        
        guard let uuidValue = UUID(uuidString: uuid) else {
            return nil
        }
        
        let major: Int? = major.isValidMajorMinor ? major : nil
        let minor: Int? = minor.isValidMajorMinor ? minor : nil
        
        if let major = major, let minor = minor {
            return CLBeaconRegion(
                uuid: uuidValue,
                major: UInt16(major),
                minor: UInt16(minor),
                identifier: prefix
            )
        }
        return CLBeaconRegion(uuid: uuidValue, identifier: prefix)
    }
    
}

extension Array where Element == Beacon {

    func first(inRegion region: CLBeaconRegion) -> Beacon? {
        first { beacon in
            region.uuidString.lowercased() == beacon.uuid.lowercased() &&
            region.major?.intValue == beacon.major &&
            region.minor?.intValue == beacon.minor
        }
    }

    func first(forBeacon clBeacon: CLBeacon) -> Beacon? {
        first { beacon in
            clBeacon.uuidString.lowercased() == beacon.uuid.lowercased() &&
            clBeacon.major.intValue == beacon.major &&
            clBeacon.minor.intValue == beacon.minor
        }
    }
}

extension Int {

    var isValidMajorMinor: Bool {
        UInt16(self) == self
    }
}


extension CLBeacon {

    var uuidString: String {
        return uuid.uuidString.lowercased()
    }
}

public extension Date {
    var millisecondsSince1970: Int {
        Int((timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension CLBeaconRegion {
    var uuidString: String {
        return uuid.uuidString.lowercased()
    }

    func toBeacon(name: String?, store: String?) -> Beacon {
        Beacon(
            uuid: uuidString,
            major: major?.intValue ?? -1,
            minor: minor?.intValue ?? -1,
            name: name
        )
    }
}
