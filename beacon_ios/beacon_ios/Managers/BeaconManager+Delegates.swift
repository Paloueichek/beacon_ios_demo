//
//  BeaconManager+Delegates.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 02/11/2022.
//

import Foundation
import CoreLocation

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
        manager.requestState(for: region)
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
