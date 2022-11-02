//
//  BeaconManager.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import Foundation


import UIKit
import CoreLocation

private enum Constant {
    static let beaconLimit: Int = 20
}

protocol BeaconLocationManagerDelegate: AnyObject {
    func onLocationManagerAuthorized(manager: BeaconManagerImp)
    func onLocationManagerError(region: CLRegion?, error: LocationError)
    func onLocationManagerRanged(regions: [CLBeacon], in region: CLBeaconRegion)
    func onLocationManagerEntered(region: CLBeaconRegion)
    func onLocationManagerLeft(region: CLBeaconRegion)
}

protocol BeaconManager {
    var delegate: BeaconLocationManagerDelegate? { get set }
    func updateMonitoredRegions(regions: [CLBeaconRegion])
    func startMonitoring(_ item: Beacon)
    func stopMonitoring(_ item: Beacon)
    func stopRanging(_ item: Beacon)
    func startRanging(_ item: Beacon)
}

final class BeaconManagerImp: NSObject, BeaconManager {
    
    weak var delegate: BeaconLocationManagerDelegate?
    private var items = [Beacon]()
    
    private var isAuthorized: Bool {
        let status: CLAuthorizationStatus
        status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        let result = [.authorizedAlways, .authorizedWhenInUse].contains(status)
        return result
    }
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 1
        manager.showsBackgroundLocationIndicator = true
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.delegate = self
        manager.activityType = .other
        return manager
    }()
    
    func startMonitoring(_ item: Beacon) {
        guard isAuthorized else {
            return
        }
        guard let region = item.toRegion(prefix: item.name ?? "") else { return }
        locationManager.startMonitoring(for: region)
    }
    
    func updateMonitoredRegions(regions: [CLBeaconRegion]) {
        guard isAuthorized else {
            return
        }
   
        if regions.count > Constant.beaconLimit {
            delegate?.onLocationManagerError(region: nil, error: .monitoringLimitReached)
        }
        
        regions.prefix(Constant.beaconLimit).forEach { region in
            region.notifyEntryStateOnDisplay = true
            region.notifyOnExit = true
            region.notifyOnEntry = true

            if !locationManager.monitoredRegions.contains(region) {
                locationManager.startMonitoring(for: region)
            }
        }
    }
    
    func stopMonitoring(_ item: Beacon) {
        guard let region = item.toRegion(prefix: item.name ?? "") else { return }
        locationManager.stopMonitoring(for: region)
    }
    
    func stopRanging(_ item: Beacon) {
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: item.uuid)!, major: CLBeaconMajorValue(item.major), minor: CLBeaconMinorValue(item.minor))
        locationManager.stopRangingBeacons(satisfying: beaconConstraint)
    }
    
    func startRanging(_ item: Beacon) {
        let beaconConstraint = CLBeaconIdentityConstraint(uuid: UUID(uuidString: item.uuid)!, major: CLBeaconMajorValue(item.major), minor: CLBeaconMinorValue(item.minor))
        locationManager.startRangingBeacons(satisfying: beaconConstraint)
    }
}
