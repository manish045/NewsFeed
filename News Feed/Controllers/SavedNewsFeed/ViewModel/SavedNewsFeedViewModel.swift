//
//  SavedNewsFeedViewModel.swift
//  News Feed
//
//  Created by Manish Tamta on 07/03/2022.
//

import Foundation
import Combine

protocol SavedNewsFeedViewProtocol: NewsFeedViewProtocol {
    func fetchSaveData()
}

final class SavedNewsFeedViewModel: SavedNewsFeedViewProtocol {
  
    var noDataFound: PassthroughSubject<Bool, Never>
    
    @Published var newsFeedArray: [FeedData]
    @Published var showLoaderBool = false
    
    var newsFeedPublisher: Published<[FeedData]>.Publisher { $newsFeedArray }
    var didGetError: PassthroughSubject<APIError, Never>
    var showLoader: PassthroughSubject<Bool, Never>

    private var limit = AppConstant.pageLimit
    private var offset = 0
    private var totalNewsCount: Int?
    private var coordinator: FeedCoordinatorView
    
    init(coordinator: FeedCoordinatorView) {
        self.coordinator = coordinator
        newsFeedArray = []
        didGetError = PassthroughSubject()
        showLoader = PassthroughSubject()
        noDataFound = PassthroughSubject()
        self.showLoader.send(true)
    }
    
    func showNewsDetail(feedData: FeedData) {
        coordinator.showDetailPage(feedData: feedData)
    }
    
    func checkForData() {
        noDataFound.send(newsFeedArray.count == 0)
    }
    
    //Fetching data from database
    func fetchSaveData() {
        newsFeedArray = NewsDBHandler.shared.fetchNews()?.toArray(type: FeedData.self) ?? []
        checkForData()
    }
}
