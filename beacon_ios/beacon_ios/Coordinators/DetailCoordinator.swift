//
//  DetailCoordinator.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 05/11/2022.
//

import UIKit


class DetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let detailVC = BeaconDetailsViewController()
        detailVC.coordinator = self
        navigationController.pushViewController(detailVC, animated: true)
        
    }
}
