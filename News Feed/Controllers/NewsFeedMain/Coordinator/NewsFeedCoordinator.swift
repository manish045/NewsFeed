//
//  NewsFeedCoordinator.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import UIKit

protocol FeedCoordinatorView {
    func showDetailPage(feedData: FeedData)
}

class NewsFeedCoordinator: Coordinator {
    
    var rootController: UINavigationController?
    private var tabBarView: UIView?
    
    init(rootController: UINavigationController?) {
        self.rootController = rootController
    }
    
    func makeModule(tabBarView: UIView?) -> UIViewController {
        let vc = createViewController(tabBarView: tabBarView)
        return vc
    }
    
    private func createViewController(tabBarView: UIView?) -> NewsFeedViewController {
        let view = NewsFeedViewController.instantiateFromStoryboard()
        let viewModel = NewsFeedViewModel(coordinator: self)
        view.viewModel = viewModel
        self.tabBarView = tabBarView
        view.tabBarView = tabBarView
        return view
    }
}
extension NewsFeedCoordinator: FeedCoordinatorView {

    func showDetailPage(feedData: FeedData) {
        let vc = NewsDetailCoordinator(rootController: rootController!).makeModule(feedModel: feedData,
                                                                                   tabBarView: tabBarView)
        self.rootController?.pushViewController(vc, animated: true)
    }
}
