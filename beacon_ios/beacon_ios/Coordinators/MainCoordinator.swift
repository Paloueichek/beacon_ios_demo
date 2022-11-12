//
//  MainCoordinator.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 05/11/2022.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let beaconManager = BeaconManagerImp()
        let listPresenter = BeaconListPresenterImp(beaconManager: beaconManager, coordinator: self)
        let listVc = BeaconListViewController(presenter: listPresenter)
        listVc.coordinator = self
        navigationController.viewControllers = [listVc]
    }
    
    func goToDetailsVC() {
        let child = DetailCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.start()
    }
    
    func removeChild(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromViewControllers = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewControllers) {
            return
        }
         
        if let detailVC = fromViewControllers as? BeaconDetailsViewController {
            removeChild(detailVC.coordinator!)
        }
    }
}
