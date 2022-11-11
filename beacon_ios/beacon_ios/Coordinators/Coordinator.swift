//
//  Coordinator.swift
//  beacon_ios
//
//  Created by Patrick Aloueichek on 05/11/2022.
//

import UIKit


protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    
    init(navigationController: UINavigationController)
    
    func start()
}


