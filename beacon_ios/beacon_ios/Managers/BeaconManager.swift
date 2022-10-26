//
//  BeaconManager.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import Foundation


import UIKit
import CoreLocation


protocol BeaconLocationManagerDelegate: AnyObject {
    
}

protocol BeaconManager {

    var delegate: BeaconLocationManagerDelegate? { get set }
    func startMonitoring(_ item: Beacon)
    func stopMonitoring(_ item: Beacon)
    func stopRanging(_ item: Beacon)
    func startRanging(_ item: Beacon)
}

final class BeaconManagerImp: NSObject, BeaconManager {
 
    var delegate: BeaconLocationManagerDelegate?
    private var items = [Beacon]()
    private var beaconLimit: Int
    
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
    
    init( beaconLimit: Int = 20) {
        self.beaconLimit = beaconLimit
    }

    func startMonitoring(_ item: Beacon) {
        guard isAuthorized else {
            return
        }
        guard let region = item.toRegion(prefix: item.name ?? "") else { return }
        locationManager.startMonitoring(for: region)
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

extension BeaconManagerImp: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("didStart: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
}
