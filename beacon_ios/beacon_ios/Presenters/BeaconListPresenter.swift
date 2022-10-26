//
//  BeaconListPresenter.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 26/10/2022.
//

import UIKit

class BeaconListPresenter {

    var fetchedBeacons: [Beacon] = []
    private let beaconManager = BeaconManagerImp()
    private let beaconStoreManager = BeaconStorageManager()
    private weak var vc: BeaconListViewController?
    
    init(vc: BeaconListViewController) {
        self.vc = vc
        self.loadItems()
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
}

 
extension BeaconListPresenter: BeaconDetailsDelegate {
    
}

