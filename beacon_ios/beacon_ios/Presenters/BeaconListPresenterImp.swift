//
//  BeaconListPresenter.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import UIKit
import CoreLocation


protocol BeaconListPresenter {
    var fetchedBeacons: [Beacon] { get set }
    func stopMonitoring(item: Beacon)
    func removeBeacon(indexPath: Int)
    func goToDetail()
    func persistItems()
    func loadItems()
}

class BeaconListPresenterImp: BeaconListPresenter {

    var fetchedBeacons: [Beacon] = []
    var allEvents: [Beacon: [EventModel]] = [:]
    private var beaconsInRange: Set<Beacon> = []
    private var monitoredRegions: [CLBeaconRegion] = []
    private var beaconManager: BeaconManager
    private let beaconStoreManager = BeaconStorageManager()
    private var summaries: [BeaconContactsSummary] = []
    private var coordinator: MainCoordinator
    
    init(beaconManager: BeaconManager, coordinator: MainCoordinator) {
        self.coordinator = coordinator
        self.beaconManager = beaconManager
        self.beaconManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(onAppEnteredBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func goToDetail() {
        coordinator.goToDetailsVC()
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
    
    func addBeacon(item: Beacon) {
        fetchedBeacons.append(item)
        beaconManager.startMonitoring(item)
        persistItems()
    }
    
    func removeBeacon(indexPath: Int) {
        beaconManager.stopMonitoring(fetchedBeacons[indexPath])
        fetchedBeacons.remove(at: indexPath)
        persistItems()
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

extension BeaconListPresenterImp : BeaconLocationManagerDelegate {
    
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
