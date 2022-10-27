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
    
    var delegate: BeaconLocationManagerDelegate?
    private var items = [Beacon]()
    private var beaconLimit: Int = 20
    
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
   
        if regions.count > beaconLimit {
            delegate?.onLocationManagerError(region: nil, error: .monitoringLimitReached)
        }
        
        regions.prefix(beaconLimit).forEach { region in
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

extension BeaconManagerImp: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("we have ranging")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
        print("didStart: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed monitoring region: \(error.localizedDescription)")
        delegate?.onLocationManagerError(region: region, error: .monitoringFailed(error: error))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
        delegate?.onLocationManagerError(region: nil, error: .locationServicesNotEnabled)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
        delegate?.onLocationManagerRanged(regions: beacons, in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        guard let beaconRegion = region as? CLBeaconRegion else {
            delegate?.onLocationManagerError(region: region, error: .wrongRegion(region: region))
            return
        }

        switch state {
            case .inside:
                delegate?.onLocationManagerEntered(region: beaconRegion)

            case .outside:
                delegate?.onLocationManagerLeft(region: beaconRegion)

            case .unknown:
                print("unknown")
        }
    }
}


public enum LocationError: Error {

    case locationServicesNotEnabled
    case monitoringNotAvailable
    case monitoringFailed(error: Error)
    case rangingNotAvailable
    case wrongRegion(region: CLRegion)
    case monitoringLimitReached
}
