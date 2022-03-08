//
//  NewsDetailViewModel.swift
//  News Feed
//
//  Created by Manish Tamta on 06/03/2022.
//

import Foundation
import UIKit

protocol NewsDetailViewProtocol {
    var feedModelData: FeedData {get set}
    var feedModelPublisher: Published<FeedData>.Publisher {get}
}

final class NewsDetailViewModel: NewsDetailViewProtocol {

    @Published var feedModelData: FeedData
    var feedModelPublisher: Published<FeedData>.Publisher {$feedModelData}
    
    private var coordinator: NewDetailCoordinatorView

    init(feedModel: FeedData,
         coordinator: NewDetailCoordinatorView) {
        self.feedModelData = feedModel
        self.coordinator = coordinator
    }
}
