//
//  Event.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import Foundation

public class EventModel {
     
    public var event: String
    public var major: String
    public var minor: String
    public var uuid: String
    public var distance: Double?
    public var rssi: Double?
    public var timestamp: Int?

    public init(event: String, major: String, minor: String, uuid: String, distance: Double? = nil, rssi: Double? = nil, timestamp: Int? = nil) {
        self.event = event
        self.major = major
        self.minor = minor
        self.uuid = uuid
        self.distance = distance
        self.rssi = rssi
        self.timestamp = timestamp
    }
    
    public func isEqual(to object: Any?) -> Bool {
      guard let object = object as? EventModel else { return false }
      guard self.event == object.event else { return false }
      guard self.major == object.major else { return false }
      guard self.minor == object.minor else { return false }
      guard self.uuid == object.uuid else { return false }
      guard self.distance == object.distance else { return false }
      guard self.rssi == object.rssi else { return false }
      guard self.timestamp == object.timestamp else { return false }
      return true
    }
    
    public static func == (lhs: EventModel, rhs: EventModel) -> Bool {
        return lhs.isEqual(to: rhs)
    }
}
