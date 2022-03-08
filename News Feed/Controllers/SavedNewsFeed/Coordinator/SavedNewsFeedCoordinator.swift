//
//  SavedNewsFeedCoordinator.swift
//  News Feed
//
//  Created by Manish Tamta on 07/03/2022.
//

import UIKit

class SavedNewsFeedCoordinator: Coordinator {
    
    var rootController: UINavigationController?
    private var tabBarView: UIView?
    
    init(rootController: UINavigationController?) {
        self.rootController = rootController
    }
    
    func makeModule(tabBarView: UIView?) -> UIViewController {
        let vc = createViewController(tabBarView: tabBarView)
        return vc
    }
    
    private func createViewController(tabBarView: UIView?) -> SavedNewsFeedViewController {
        let view = SavedNewsFeedViewController.instantiateFromStoryboard()
        let viewModel = SavedNewsFeedViewModel(coordinator: self)
        view.viewModel = viewModel
        self.tabBarView = tabBarView
        view.tabBarView = tabBarView
        return view
    }
}

extension SavedNewsFeedCoordinator: FeedCoordinatorView {

    func showDetailPage(feedData: FeedData) {
        let vc = NewsDetailCoordinator(rootController: rootController!).makeModule(feedModel: feedData,
                                                                                   tabBarView: tabBarView,
                                                                                   showSaveBarButton: false)
        self.rootController?.pushViewController(vc, animated: true)
    }
}
