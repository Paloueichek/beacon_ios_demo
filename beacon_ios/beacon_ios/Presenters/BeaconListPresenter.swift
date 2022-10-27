//
//  BeaconListPresenter.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import UIKit
import CoreLocation

class BeaconListPresenter {

    var fetchedBeacons: [Beacon] = []
    var beaconsInRange: Set<Beacon> = []
    var allEvents: [Beacon: [EventModel]] = [:]
    var monitoredRegions: [CLBeaconRegion] = []
    private let beaconManager = BeaconManagerImp()
    private let beaconStoreManager = BeaconStorageManager()
    private weak var vc: BeaconListViewController?
    
    var summaries: [BeaconContactsSummary] = []
    
    init(vc: BeaconListViewController) {
        self.vc = vc
        self.loadItems()
        beaconManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onAppEnteredBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func stopMonitoring(item: Beacon) {
        beaconManager.stopMonitoring(item)
    }
    
    func persistItems() {
        self.beaconStoreManager.saveBeacons(beacons: fetchedBeacons)
    }
    
    func loadItems() {
       fetchedBeacons = self.beaconStoreManager.loadBeacons()
    }
    
    @objc func addBeaconButtonPressed(_ sender: Any) {
        let detailsVC = BeaconDetailsViewController()
        detailsVC.delegate = self
        vc?.navigationController?.present(detailsVC, animated: true)
        vc?.tableView.reloadData()
    }
    
    func addBeacon(item: Beacon) {
        fetchedBeacons.append(item)
        
        vc?.tableView.beginUpdates()
        let newIndexPath = IndexPath(row: fetchedBeacons.count - 1, section: 0)
        vc?.tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        vc?.tableView.endUpdates()
        persistItems()
        beaconManager.startMonitoring(item)
    }
    
    func removeBeacon(indexPath: Int) {
        beaconManager.stopMonitoring(fetchedBeacons[indexPath])
        fetchedBeacons.remove(at: indexPath)
     
        let newIndexPath = IndexPath(row: fetchedBeacons.count , section: 0 )
        vc?.tableView.beginUpdates()
        vc?.tableView.deleteRows(at: [newIndexPath], with: .automatic)
        vc?.tableView.endUpdates()
      
        persistItems()
        vc?.tableView.reloadData()
    }
    
    
    func ranged(beacon: Beacon, event: EventModel) {
        beaconsInRange.insert(beacon)
        
        if let beaconEvents = allEvents[beacon] {
            var newBeaconEvents = beaconEvents
            newBeaconEvents.append(event)
            if newBeaconEvents.count > 100 {
                newBeaconEvents = newBeaconEvents.sorted(by: { ($0.timestamp ?? 0) > ($1.timestamp ?? 0) }).dropLast(1)
            }
            allEvents[beacon] = newBeaconEvents
        } else {
            allEvents[beacon] = [event]
        }
    }
    
    @objc private func onAppEnteredBackground() {
        beaconManager.updateMonitoredRegions(regions: monitoredRegions)
    }

    
    private func updateSummaries() {
        summaries = allEvents.map {
            BeaconContactsSummary(beacon: $0.key, events: $0.value, isInRange: beaconsInRange.contains($0.key))
        }
        .sorted { item1, item2 in
            if item1.isInRange != item2.isInRange {
                return item1.isInRange
            }
            if item1.timestamp == item2.timestamp {
                return item1.name < item2.name
            }
            if let timestamp1 = item1.timestamp, let timestamp2 = item2.timestamp {
                return timestamp1 > timestamp2
            }
            if item1.timestamp != nil {
                return true
            }
            return false
        }
    }
}

 
extension BeaconListPresenter: BeaconDetailsDelegate {
    
}

extension BeaconListPresenter : BeaconLocationManagerDelegate {
    
    func onLocationManagerAuthorized(manager: BeaconManagerImp) {
        
    }
    
    func onLocationManagerError(region: CLRegion?, error: LocationError) {
        
    }
    
    func onLocationManagerRanged(regions: [CLBeacon], in region: CLBeaconRegion) {
        let beacons: [Beacon] = regions.compactMap { region in
            let result = fetchedBeacons.first(forBeacon: region)
            return result
        }
        monitoredRegions.append(region)
        beaconsInRange.formUnion(beacons)
        regions.forEach { region in
            guard let beacon = fetchedBeacons.first(forBeacon: region), beaconsInRange.contains(beacon) else {
                return
            }
            let event = region.toEvent(event: .in)
            ranged(beacon: beacon, event: event)
        }

    }
    
    func onLocationManagerEntered(region: CLBeaconRegion) {
        
    }
    
    func onLocationManagerLeft(region: CLBeaconRegion) {
        
    }
}
