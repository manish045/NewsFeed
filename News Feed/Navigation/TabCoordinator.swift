//
//  TabCoordinator.swift
//  News Feed
//
//  Created by Manish Tamta on 07/03/2022.
//

import Foundation

import UIKit

// Name of the coordinators/stacks
enum ViewControllerItem: Int {
    case first = 0
    case second = 1
    
    var title: String {
        switch self {
        case .first:
            return "News"
        case .second:
            return "Saved News"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .first:
            return UIImage(systemName: "1.circle")
        case .second:
            return UIImage(systemName: "2.circle")
        }
    }
    
    var filledIcon: UIImage? {
        switch self {
        case .first:
            return UIImage(systemName: "1.circle.fill")
        case .second:
            return UIImage(systemName: "2.circle.fill")
        }
    }
}

protocol TabBarSourceType {
    var items: [UINavigationController] {get set}
}

final class TabBarSource: TabBarSourceType {
    var items: [UINavigationController] = [
        UINavigationController(nibName: nil, bundle: nil),
        UINavigationController(nibName: nil, bundle: nil)
    ]
    
    // Initialise the TabBar items with name and Icons
    init() {
        let firstIcon = ViewControllerItem.first.icon
        let filledFirstIcon = ViewControllerItem.first.filledIcon
        self[.first].tabBarItem = UITabBarItem(title: ViewControllerItem.first.title, image: firstIcon, selectedImage: filledFirstIcon)
        let secondIcon = ViewControllerItem.second.icon
        let filledSecondIcon = ViewControllerItem.second.filledIcon
        self[.second].tabBarItem = UITabBarItem(title: ViewControllerItem.second.title, image: secondIcon, selectedImage: filledSecondIcon)
    }
}

// transform the index of the item in "items" into a case of the enum ViewControllerItem
extension TabBarSourceType {
    subscript(item: ViewControllerItem) -> UINavigationController {
        get {
            guard !items.isEmpty, item.rawValue < items.count, item.rawValue >= 0 else {
                fatalError("Item does not exist")
            }
            return items[item.rawValue]
        }
    }
}

final class TabCoordinator: NSObject {
    
    // MARK: - Properties
    
    private let router: UIWindow
    private let tabBarController: UITabBarController
    private var firstCoordinator: NewsFeedCoordinator?
    private var secondCoordinator: SavedNewsFeedCoordinator?
    private var source: TabBarSource = TabBarSource()
    
    // MARK: - Initializer
    
    init(router: UIWindow) {
        self.router = router
        tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = source.items
        tabBarController.selectedViewController = source[.first]
        super.init()
        
        tabBarController.delegate = self
    }
    
    // setting instance of UINavigationController and initializing first tab controller
    func start() {
        router.rootViewController = tabBarController
        addFirstTab()
        addSecondTab()
    }
    
    private func addFirstTab() {
        firstCoordinator = NewsFeedCoordinator(rootController: source[.first])
        let viewController = firstCoordinator?.makeModule(tabBarView: self.tabBarController.tabBar)
        source[.first].viewControllers = [viewController!]
    }
    
    private func addSecondTab() {
        secondCoordinator = SavedNewsFeedCoordinator(rootController: source[.second])
        let viewController = secondCoordinator?.makeModule(tabBarView: self.tabBarController.tabBar)
        source[.second].viewControllers = [viewController!]
    }
}

// get the rawvalue of the selected item, and call the relative func show()
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let index = tabBarController.selectedIndex
        guard index < source.items.count, let item = ViewControllerItem(rawValue: index) else {
            fatalError("Index out of range")
        }
        
        switch item {
        case .first:
            tabBarController.selectedViewController = source[.first]
        case .second:
            tabBarController.selectedViewController = source[.second]
        }
    }
}
