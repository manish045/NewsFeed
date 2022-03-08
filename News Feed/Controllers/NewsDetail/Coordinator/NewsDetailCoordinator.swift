//
//  NewsDetailCoordinator.swift
//  News Feed
//
//  Created by Manish Tamta on 06/03/2022.
//

import Foundation
import UIKit

protocol NewDetailCoordinatorView {
    
}

class NewsDetailCoordinator: Coordinator {
    
    var rootController: UINavigationController?
    
    init(rootController: UINavigationController?) {
        self.rootController = rootController
    }
    
    func makeModule(feedModel: FeedData,
                    tabBarView: UIView?,
                    showSaveBarButton: Bool = true) -> UIViewController {
        let vc = createViewController(feedModel: feedModel,
                                      tabBarView: tabBarView,
                                      showSaveBarButton: showSaveBarButton)
        return vc
    }

    private func createViewController(feedModel: FeedData,
                                      tabBarView: UIView?,
                                      showSaveBarButton: Bool = true) -> NewsDetailViewController {
        let view = NewsDetailViewController.instantiateFromStoryboard()
        let viewModel = NewsDetailViewModel(feedModel: feedModel,
                                            coordinator: self)
        view.tabBarView = tabBarView
        view.viewModel = viewModel
        view.showSaveBarButton = showSaveBarButton
        return view
    }
}

extension NewsDetailCoordinator: NewDetailCoordinatorView {

}
