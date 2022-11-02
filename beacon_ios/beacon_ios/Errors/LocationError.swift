//
//  LocationError.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 02/11/2022.
//

import Foundation
import CoreLocation

public enum LocationError: Error {

    case locationServicesNotEnabled
    case monitoringNotAvailable
    case monitoringFailed(error: Error)
    case rangingNotAvailable
    case wrongRegion(region: CLRegion)
    case monitoringLimitReached
}
