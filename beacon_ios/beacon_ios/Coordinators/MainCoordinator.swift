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
    
    func goToDetailsVC(delegate: BeaconDetailsDelegate) {
        let detailVC = BeaconDetailsViewController()
        detailVC.delegate = delegate
        detailVC.coordinator = self
        navigationController.pushViewController(detailVC, animated: true)
    }
///MARK: For future purposes when we can have more child coordinators that will need to be removed when we enter more data
    func removeChild(_ child: Coordinator) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
///MARK: For future purposes when want to create more coordinators and successfully remove them
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromViewControllers = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewControllers) {
            return
        }
    }
}

extension MainCoordinator {
    func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}
