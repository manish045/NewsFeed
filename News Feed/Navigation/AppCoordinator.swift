//
//  AppCoordinator.swift
//  News Feed
//
//  Created by Manish Tamta on 07/03/2022.
//

import Foundation

final class AppCoordinator {
    
    // MARK: - Properties
    
    private unowned var sceneDelegate: SceneDelegate
    
    private var tabcoordinator: TabCoordinator?
    
    // MARK: - Initializer
    
    init(sceneDelegate: SceneDelegate) {
        self.sceneDelegate = sceneDelegate
    }
    
    // MARK: - Coordinator
    // setting up intial controller
    func start() {
        tabcoordinator = TabCoordinator(router: sceneDelegate.window!)
        tabcoordinator?.start()
    }
}
